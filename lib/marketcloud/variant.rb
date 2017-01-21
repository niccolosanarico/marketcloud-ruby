module Marketcloud
  class Variant
    attr_accessor :id,
                  :variant_id,
                  :product_id,
                  :name,
                  :sku,
                  :description,
                  :slug,
                  :images,
                  :price,
                  :weight, :depth, :width, :height,
                  :stock_status


    def initialize(attributes, definitions)
      @id = attributes['id']
      @variant_id = attributes['variant_id']
      @product_id = attributes['product_id']
      @name = attributes['name']
      @sku = attributes['sku']
      @description = attributes['description']
      @slug = attributes['slug']
      @price = attributes['price']
      @images = attributes['images']
      @weight = attributes['weight'] || 1
      @depth = attributes['depth'] || 1
      @width = attributes['width'] || 1
      @height = attributes['height'] || 1
      @stock_status = attributes['stock_status']

      # add the custom attributes for the variant
      definitions.each do |k, v|
        key = k.downcase
        self.class.class_eval { attr_accessor key }
        instance_variable_set "@#{key}", attributes[k]
      end
    end
  end
end
