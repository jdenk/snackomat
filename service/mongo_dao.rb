require 'mongo'
require 'bson'
require 'securerandom'

module Snackomat
  class MongoService

    def initialize
      ENV['PROD_MONGODB'] = 'mongodb://heroku_7nwz6sv6:vq5te60bvdg8a730giuhr8krqa@ds029605.mongolab.com:29605/heroku_7nwz6sv6'
      @client = Mongo::Client.new(ENV['PROD_MONGODB'])
    end


    def get_user_settings(user)
      res = @client[:user_config].find({id: user}).to_a.first
      res.delete(:_id)
      res
    end

    def upsert_user_settings(user, config)
      @client[:user_config].update_one({id: user}, {id: user, user_config: config}, {:upsert => true})
    end

    def generate_token(email)
      uuid = SecureRandom.uuid
      @client[:tokens].update_one({email: email}, {email: email, token: uuid}, {:upsert => true})
    end
  end
end



