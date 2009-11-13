require "#{File.dirname(__FILE__)}/../lib/cesium/config"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/abstract"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/pages"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/snippets"

namespace :cesium do

  namespace :cache do
    desc "Clear cesium cache"
    task :clear do
      Cesium::Cache::Pages.new.clear
      Cesium::Cache::Snippets.new.clear
    end
  end

  namespace :db do
    desc "Dump cesium pages, layouts and snippets into yaml file."
    task :dump => :environment do
      ActiveRecord::Base.establish_connection(RAILS_ENV)
      filename = File.join(RAILS_ROOT, (ENV['FILE'] || "cesium_dump_#{Time.now.strftime("%Y%m%d%H%M%S")}") + '.yml')
      yaml_hash = {}
      [Page, PagePart, Layout, Snippet].each do |model|
        model_hash = {}
        p "Dumping #{model.class_name.tableize}"
        model.all.each do |m|
          model_hash.merge!({ "#{model.class_name.underscore}_#{m.id}".to_sym => m.attributes })
        end
        yaml_hash.merge!({ model.class_name.tableize.to_sym => model_hash })
      end
      yaml_obj = YAML::dump(yaml_hash)
      p "Writing dump into #{filename}"
      File.open(filename, 'w') do |file|
        file.write(yaml_obj)
      end
    end

    desc "Load cesium pages, layouts and snippets from yaml file. Destroys all previosly data."
    task :load => :environment do
      ActiveRecord::Base.establish_connection(RAILS_ENV)
      filename = File.join(RAILS_ROOT, ENV['FILE']) if ENV['FILE']
      filename ||= Dir.glob(File.join(RAILS_ROOT, 'cesium_dump_*.yml')).last
      p "Reading dump from #{filename}"
      yaml_obj = YAML.load_file(filename)
      ActiveRecord::Base.transaction do
        [Page, PagePart, Layout, Snippet].each do |model|
          p "Clearing #{model.class_name.tableize}"
          model.delete_all
          p "Loading #{model.class_name.tableize}"
          model_hash = yaml_obj[model.class_name.tableize.to_sym].values
          if model == Page
            model_hash.sort! { |a, b| a['lft'] <=> b['lft'] }
            model_hash.each do |m|
              model.create(m) do |r|
                r.id = m['id']
                r.save!
                r.move_to_child_of m['parent_id'] if m['parent_id']
                r.rebuild_paths
              end
            end
          else
            model_hash.each do |m|
              model.create(m) do |r|
                r.id = m['id']
              end
            end
          end
        end
      end
    end

    desc "Migrate cesium models"
    task :migrate => :environment do
      ActiveRecord::Migrator.migrate(File.join(RAILS_ROOT, 'vendor/plugins/cesium/db/migrate'), ENV["PLUGIN_VERSION"] ? ENV["PLUGIN_VERSION"].to_i : nil)
    end

    desc "Migrate all application models include cesium"
    task 'migrate:application' => :environment do
      Rake::Task["db:migrate"].invoke
      Rake::Task["cesium:db:migrate"].invoke
    end

  end
end
