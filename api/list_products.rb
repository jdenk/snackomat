require_relative '../service/rohlik_service'

module Snackomat
  class Products < Grape::API
    format :json
    get '/products' do
      RohlikService.get_supported_categories
    end
  end
end
