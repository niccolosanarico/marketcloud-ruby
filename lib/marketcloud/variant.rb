module Marketcloud

  attr_accessor :id,
                :variant_id,
                :product_id,
                :name,
                :sku,
                :description,
                :images,
                :price,
                :weight, :depth, :width, :height


  def initialize(attributes)
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
  end

end
