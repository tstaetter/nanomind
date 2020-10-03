# frozen_string_literal: true

module NanoMind
  module Errors
    # Basic error class
    class NanoMindError < StandardError; end
    # Used to indicate errors using the DSL
    class DSLError < NanoMindError; end
  end
end
