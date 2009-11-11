class LayoutError < StandardError
end

class Page < ActiveRecord::Base

  include Cesium::Layout

  attr_accessor :child_pages

  default_scope :order => :lft, :include => :page_parts

  has_many :page_parts, :dependent => :destroy
  belongs_to :layout

  acts_as_nested_set

  validates_presence_of :title
  validates_uniqueness_of :name, :scope => :parent_id
  validates_format_of :name,
    :with => /\A([a-zA-Z0-9]+[\w-]*(\.[a-zA-Z0-9]+)?|\*)\Z/,
    :message => "can looks like 'about', 'style.css' or '*'",
    :unless => Proc.new { |page| page.name == '/' }
  validates_inclusion_of :status, :in => 0..2

  after_move :rebuild_level_cache, :clear_cesium_pages_cache

  attr_protected :path

  after_update :clear_cesium_pages_cache
  after_destroy :clear_cesium_pages_cache

  def rebuild_paths
    if self.parent_id.nil?
      self.update_attribute :name, '/'
      self.update_attribute :path, '/'
    else
      saved_path = self.path
      parent_path = self.parent.parent_id ? self.parent.path : ''
      new_path = parent_path + '/' + self.name
      Page.update_all "path = REPLACE(path, '#{saved_path}', '#{new_path}')", ["path like ?", saved_path + '%'] if saved_path
      self.update_attribute :path, new_path unless self.path
    end
  end

  def rebuild_level_cache
    level_cache = self.level_cache
    self.update_attribute(:level_cache, self.level)
    descendants = self.descendants
    p descendants
    Page.update_all "level_cache = level_cache + #{self.level_cache - level_cache}",
      "id in (#{descendants.map(&:id).join(',')})" unless level_cache == 0 || descendants.empty?
  end

  def self.find_page path
    find_by_path path
  end

  def additional_parts
    ancestors_id = self.ancestors.map { |p| p.id }
    exclude = self.page_parts.map { |p| "name <> '#{p.name}'" }.join(' and ')
    PagePart.find_all_by_page_id(ancestors_id, :conditions => exclude, :order => 'page_id desc')
  end

  def get_layout
    page = self.layout_id.nil? ? self.ancestors.reverse.detect { |i| i.layout_id != nil} : self
    if page && page.layout_id
      Layout.find(page.layout_id)
    else
      raise LayoutError.new('There is no layout at the root page')
    end
  end

  def parser_init controller = nil
    @context ||= Radius::PageContext.new self, controller
    @parser ||= Radius::Parser.new(@context, :tag_prefix => 'r')
  end

  def build_page
    @pages_cache ||= Cesium::Cache::Pages.new
    if @pages_cache.exists? self.path
      logger.info("Render page '#{self.path}' from cache")
      @pages_cache.read self.path
    else
      text = parser_init('pages').parse(self.get_layout.body)
      text = @context.tag_tracker.parse(text)
      @pages_cache.write self.path, text
    end
  end

  def parse text, filter_erb = false
    text = parser_init('pages').parse text
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
