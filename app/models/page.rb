class LayoutError < StandardError
end

class Page < ActiveRecord::Base

  include Cesium::Layout

  acts_as_nested_set

  attr_accessor :child_pages

  default_scope :order => :lft
  named_scope :with_parts, :include => :page_parts

  has_many :page_parts, :dependent => :destroy
  belongs_to :layout

  validates_presence_of :title
  validates_uniqueness_of :name, :scope => :parent_id
  validates_format_of :name,
    :with => /\A([a-zA-Z0-9]+[\w-]*(\.[a-zA-Z0-9]+)?|\*)\Z/,
    :message => "can looks like 'about', 'style.css' or '*'",
    :unless => Proc.new { |page| page.name == '/' }
  validates_inclusion_of :status, :in => 0..2

  attr_protected :path

  after_create :move_page
  after_move :clear_cesium_pages_cache, :update_level_cache, :update_paths
  after_update :clear_cesium_pages_cache, :update_paths
  after_destroy :clear_cesium_pages_cache

  def move_page
    if self.parent_id
      self.move_to_child_of self.parent_id
    else
      self.update_paths
    end
  end

  def update_paths
    if self.parent_id
      saved_path = self.path
      parent_path = self.parent.parent_id ? self.parent.path : ''
      new_path = parent_path + '/' + self.name
      Page.update_all "path = REPLACE(path, '#{saved_path}', '#{new_path}')", ["path like ?", saved_path + '%'] if saved_path unless saved_path == new_path
      Page.update_all "path = '#{new_path}'", ["id = ?", self.id] unless self.path
    else
      Page.update_all "path = '/', name = '/'", "parent_id is null"
    end
  end

  def update_level_cache
    level_cache = self.level_cache
    descendants = self.descendants
    Page.update_all "level_cache = '#{self.level}'", ["id = ?", self.id]
    Page.update_all "level_cache = level_cache + #{self.level_cache - level_cache}",
      "id in (#{descendants.map(&:id).join(',')})" unless level_cache == 0 || descendants.empty?
  end

  def additional_parts
    parts_names = self.page_parts.map { |p| p.name }
    ancestors = self.ancestors
    additional = []
    ancestors.reverse.each do |a|
      a.page_parts.each do |p|
        unless parts_names.include? p.name
          p.additional = true
          additional << p
          parts_names << p.name
        end
      end
    end
    additional
  end

  def all_parts
    (page_parts + additional_parts).sort { |a, b| a.name <=> b.name }
  end

  def layout?
    self.path.include?('*')
  end

  def get_layout
    page = self.layout_id.nil? ? self.ancestors.reverse.detect { |i| i.layout_id != nil} : self
    if page && page.layout_id
      Layout.find(page.layout_id)
    else
      raise LayoutError.new('There is no layout at the root page')
    end
  end

  def parser_init
    @context ||= Radius::PageContext.new self
    @parser ||= Radius::Parser.new(@context, :tag_prefix => 'r')
  end

  def build_page
    @pages_cache ||= Cesium::Cache::Pages.new
    if @pages_cache.exists? self.path
      logger.info("Render page '#{self.path}' from cache")
      @pages_cache.read self.path
    else
      text = parser_init.parse(self.get_layout.body)
      text = @context.tag_tracker.parse(text)
      @pages_cache.write self.path, text
    end
  end

  def parse text, filter_erb = false
    text = parser_init.parse text
    filter_erb ? @context.tag_tracker.parse(text) : text
  end

  def content_type
    Rack::Mime.mime_type(File.extname(self.name), 'text/html')
  end

  def statuses
    {:hidden => 2, :published => 1, :draft => 0}
  end

  def draft?
    self.status == statuses[:draft]
  end

  def hidden?
    self.status == statuses[:hidden]
  end

end
