module Cesium

  mattr_accessor :options
  @@config = HashWithIndifferentAccess.new({
    :own_auth => false,
    :own_controllers => false,
    :allow_cache => true,
    :allow_erb => false,
    :cache_path => File.join(RAILS_ROOT, 'tmp/cesium_cache')
  })

  def self.config
    unless @options
      config_file = File.join(RAILS_ROOT, 'config/cesium.yml')
      yaml = YAML.load_file(config_file) if File.exists?(config_file)
    end
    @options ||= @@config.update(yaml ? yaml : {})
  end

end
