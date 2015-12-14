module Snackomat
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Snackomat::Products
  end
end
