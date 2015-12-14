module Snackomat
  class App
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
      request_path = env['PATH_INFO'];

      puts request_path
      if(request_path == '/' || request_path == '')
        env['PATH_INFO'] = '/api/products'
      end

      # api
      response = Snackomat::API.call(env)

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
