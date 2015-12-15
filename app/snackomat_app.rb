module Snackomat
  class App

    def initialize
      @rack_static = ::Rack::Static.new(
          lambda { [404, {}, []] },
          root: File.expand_path('../../public', __FILE__),
          urls: ['/']
      )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Snackomat::App.new
      end.to_app
    end

    def call(env)

      # api
      response = Snackomat::API.call(env)

      if response[1]['X-Cascade'] == 'pass'
        # static files
        request_path = env['PATH_INFO']
        if(request_path == '/' || request_path == '')
          response = @rack_static.call(env.merge('PATH_INFO' => "/index.html"))
          return response if response[0] != 404
        end
      end


      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end
end
