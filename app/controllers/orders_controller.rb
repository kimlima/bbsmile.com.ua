class OrdersController < ApplicationController
  before_action :reject_spam

  def create
    order = Order.new order_params
    respond_to do |format|
      if order.save
        flash.now[:success] =
          I18n.t(
            'flash.message.orders.created',
            order_id: order.id,
            when_callback: I18n.t("flash.message.orders.call_#{when_callback}")
          )
        format.json { render json: order.as_json.merge(flashes_in_json), status: :created }
      else
        format.json { render json: order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :variant_id, :notes,
      user_attributes: [:name, :email, :phone, :subscribed],
      suborders_attributes: [[:variant_id]]
    )
  end

  def when_callback
    case Time.current.hour
    when 9..19
      'now'
    when 19..23
      'tomorrow'
    else
      'morning'
    end
  end

  def reject_spam
    render nothing: true, status: 403 if params[:text].present?
  end
end
