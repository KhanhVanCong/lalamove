# frozen_string_literal: true

module Lalamove
  module Entities
    class QuotationStop < Base
      attribute :coordinates, QuotationLocation.meta(omittable: true)
      attribute :address, Types::String
    end
  end
end
