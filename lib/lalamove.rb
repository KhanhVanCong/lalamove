# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'lalamove/version'

require 'lalamove/configuration'
require 'lalamove/client'
require 'lalamove/errors'

require 'active_service/base'
require 'active_service/response'
require 'faraday'

require 'lalamove/entities/base'
require 'lalamove/entities/address'
require 'lalamove/entities/customer'
require 'lalamove/entities/delivery'
require 'lalamove/entities/quotation_location'
require 'lalamove/entities/order_sender'
require 'lalamove/entities/quotation_stop'
require 'lalamove/entities/quotation'
require 'lalamove/entities/order'
require 'lalamove/entities/location'
require 'lalamove/entities/driver_details'

require 'lalamove/resources/quotation'
require 'lalamove/resources/place_order'
require 'lalamove/resources/order_cancel'
require 'lalamove/resources/order_detail'
require 'lalamove/resources/driver_details'
require 'lalamove/resources/city_info'
require 'lalamove/resources/quotation_detail'

require 'lalamove/services/request_service'
require 'lalamove/services/quotation_service'
require 'lalamove/services/order_creator_service'
require 'lalamove/services/order_cancel_service'
require 'lalamove/services/order_detail_service'
require 'lalamove/services/driver_details_service'
require 'lalamove/services/city_info_service'
require 'lalamove/services/quotation_detail_service'

module Lalamove
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.client
    Client
  end
end
