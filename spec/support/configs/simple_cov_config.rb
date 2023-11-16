# frozen_string_literal: true

# require 'simplecov_json_formatter'
require 'simplecov'
require 'simplecov-json'

module SimpleCovConfig
  def self.configure
    SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

    SimpleCov.minimum_coverage 90
    SimpleCov.start do
      add_filter { |source_file| cover?(source_file.lines) }
      add_filter '/spec/'
    end
  end

  def self.cover?(lines)
    !lines.detect { |line| line.src.match?(/(def |attributes)/) }
  end
end

class String
  def match?(pattern)
    pattern = Regexp.new(Regexp.escape(pattern)) unless pattern.is_a?(Regexp)
    !!(self =~ pattern)
  end
end
