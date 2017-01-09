module Marketcloud
  class Variant
    attr_accessor :id,
                  :variant_id,
                  :product_id,
                  :name,
                  :sku,
                  :description,
                  :images,
                  :price,
                  :weight, :depth, :width, :height


    def initialize(attributes, definitions)
      @id = attributes['id']
      @variant_id = attributes['variant_id']
      @product_id = attributes['product_id']
      @name = attributes['name']
      @sku = attributes['sku']
      @description = attributes['description']
      @price = attributes['price']
      @images = attributes['images']
      @weight = attributes['weight']
      @depth = attributes['depth']
      @width = attributes['width']
      @height = attributes['height']

      # add the custom attributes for the variant
      definitions.each do |k, v|
        key = k.downcase
        self.class.class_eval { attr_accessor k }
        self.send("#{key}=", attributes[k])
      end
    end
  end
end
