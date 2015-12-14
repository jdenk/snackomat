require 'rest-client'
require 'json'

module Snackomat

  class RohlikService
    class << self

      def get_supported_categories
        categories = get_categories
        products = get_products

        res = categories.map do |category|
          filtered_products = products.select { |prod| prod['categories'].map { |cat| cat['id'] }.include? category['id'] }
          category.store('products', filtered_products)
          category
        end

        res.each do |cat|
          cat['products'].each do |prod|
            prod.delete "categories"
          end
        end

      end


      private

      SUPPORTED_CATEGORIES = [75413, 75447, 75477, 75591, 75607, 79065, 79067,
                              87537, 132219, 133125, 133285, 133401, 133405, 133419, 133449, 133515, 133543, 133549, 133669,
                              133671, 133677, 133681, 133687, 133689, 133713, 133715, 133723, 133763, 134049, 134137, 134139,
                              134141, 134189, 134193, 134349, 134351, 134373, 134381, 134429]


      PRODUCT_ATTRIBUTES_TO_DELETE = ["ean", "badge", "country_of_origin", "ingredients", "popularity", "primary_category", "unit", "weight", "weight_variations", "description"]
      CATEGORY_ATTRIBUTES_TO_DELETE = ["parent_id", "position"]


      def get_products
        products = JSON.parse(RestClient::Request.execute(:url => 'https://www.rohlik.cz/api/v2/products', :method => :get, :verify_ssl => false))
        filtered_products = products['products'].select { |prod| (prod['categories'].map { |cat| cat['id'] } & SUPPORTED_CATEGORIES).any? }
        filtered_products.each do |prod|
          prod.delete_if { |key, value| PRODUCT_ATTRIBUTES_TO_DELETE.include? key }
        end
      end

      def get_categories
        categories = JSON.parse(RestClient::Request.execute(:url => 'https://www.rohlik.cz/api/v2/categories', :method => :get, :verify_ssl => false))
        filtered_categories = categories['categories'].select { |cat| SUPPORTED_CATEGORIES.include? cat['id'] }
        filtered_categories.each do |cat|
          cat.delete_if { |key, value| CATEGORY_ATTRIBUTES_TO_DELETE.include? key }
        end
      end
    end

  end

end








