# frozen_string_literal: true

module Lalamove
  class LalamoveError < StandardError
    attr_reader :message, :code

    def initialize(message: nil, code: nil)
      super(message)
      @message = message
      @code = code
    end
  end

  class QuotationError < LalamoveError
  end
end