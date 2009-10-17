module Cesium
  module Rack

    class StaticOverlay

      def initialize(app, root)
        @app = app
        @servers = {}
        @root = root
        @public = ::Rack::File.new(root)
      end

      def call(env)
        req = ::Rack::Request.new(env)
        resource = URI.parse(req.url).path
        resource_path = File.join(@root, resource)
        if File.exist?(resource_path) and File.file?(resource_path)
          return @public.call(env)
        end
        return @app.call(env)
      end

    end

  end
end
