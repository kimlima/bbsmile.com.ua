class Suborder < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :variant
  after_validation :memorize_price, unless: -> { errors.any? }
  validates :variant, presence: true
  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }

  def total
    price * quantity
  end

  def total_with_currency
    number_to_currency total
  end

  def title
    variant.title
  end

  def merge_with suborder
    self[:quantity] += suborder.quantity if variant == suborder.variant
  end

  private

  def memorize_price
    self[:price] = variant.price
  end
end