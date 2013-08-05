class Variant < ActiveRecord::Base
  include PgSearch

  belongs_to :product
  has_one :image, as: :assetable, dependent: :destroy

  scope :visible, -> { joins(product: [:page]).where("pages.hidden" => false) }
  pg_search_scope :by_sku, against: :sku

  attr_accessor :delete_image

  accepts_nested_attributes_for :image, reject_if: :all_blank
  acts_as_list scope: [:product_id]

  default_scope -> { order(:position) }
  scope :discounts, -> { where self.arel_table[:price_old].not_eq(nil) }

  validates :price, :price_old,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :available, :master, inclusion: { in: [true, false] }
  validate :price_old_cannot_be_less_than_price

  normalize_attribute :delete_image, with: :booleanize

  before_save :destroy_image, if: "delete_image"

  def title
    [product.title, name, sku].reject(&:blank?).join(' ')
  end

  def category_title
    product.category.title
  end

  def brand_name
    product.brand.try(:name)
  end

  private

  def destroy_image
    self.image = nil
  end

  def price_old_cannot_be_less_than_price
    if price_old && price_old <= price
      errors.add :price_old, I18n.t('errors.models.variant.price_old')
    end
  end
end
