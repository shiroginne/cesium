module Cesium
  class TagTracker
    def initialize
      @ids = []
    end

    def wrap content
      @ids << uid
      content.gsub(/<%/, "<#{@ids.last}%").gsub(/%>/, "%#{@ids.last}>")
    end

    def parse text
      ids = @ids.join('|')
      @ids = []
      text.gsub!(/<%/, "&lt;%").gsub!(/%>/, "%&gt;") if Cesium::Config.filter_erb
      text.gsub(/<(#{ids})%/, "<%").gsub(/%(#{ids})>/, "%>")
    end

    private

    def uid
      Digest::MD5.hexdigest("#{rand}#{Time.now.to_f}")
    end

  end
end
