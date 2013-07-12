module Pageable
  extend ActiveSupport::Concern

  included do
    has_one :page, as: :pageable, dependent: :destroy
    accepts_nested_attributes_for :page
    delegate :title, :name, :url, :url_old, :hidden, to: :page
  end
end