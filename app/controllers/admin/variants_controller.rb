class Admin::VariantsController < Admin::ApplicationController

  def index
    @product = product
    @variant = @product.variants.new
    @product.variants.reload
  end

  def create
    @product = product
    @variant = @product.variants.new variant_params
    if @variant.save
      @variant.move_to_bottom
      redirect_to [:admin, @product, :variants], notice: I18n.t('flash.message.variants.created')
    else
      @product.variants.reload
      render :index
    end
  end

  def edit
    @variant = variant
    @product = @variant.product
  end

  def update
    @variant = variant
    @product = @variant.product
    if @variant.update(variant_params)
      redirect_to admin_product_variants_url(@product), notice: I18n.t('flash.message.variants.updated')
    else
      render :edit
    end
  end

  def sort
    variant.insert_at params[:position].to_i
    head :ok
  end

  def destroy
    variant.destroy
    flash.now[:notice] = I18n.t 'flash.message.variants.destroyed'
    render json: flashes_in_json
  end

  private
    def variant_params
      params.require(:variant).permit(
        :name, :sku, :price, :price_old, :available, :master, :delete_image,
        image_attributes: [:attachment, :attachment_url, :id]
      )
    end

    def product
      Product.find params[:product_id]
    end

    def variant
      Variant.find params[:id]
    end
end
