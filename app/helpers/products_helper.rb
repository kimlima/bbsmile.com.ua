module ProductsHelper

  def variant_image_url(variant, style = nil)
    image = if variant.image.present?
      variant.image
    elsif variant.master?
      variant.product.images.first
    end
    image.url(style) if image
  end

  def product_share_data
    {
      url:   product_page_url(@product.url),
      title: @product.title,
      image: @product.top_image? ?
               URI.join(request.url, @product.top_image(:medium)) : ''
    }
  end
end
