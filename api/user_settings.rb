require_relative '../service/rohlik_service'

module Snackomat
  class UserSettings < Grape::API
    format :json
    get '/user_settings' do
      MongoService.get_user_settings
    end
    put '/user_settings' do
      MongoService.upsert_user_settings
    end
  end
end
