# frozen_string_literal: true

module NanoMind
  module DSL
    module Declaration
      ##
      # DSL for layer declaration
      #
      class Layer
        attr_reader :name, :output_stack, :input_stack, :max_number, :keep_alive, :nanite_template, :evt_handlers

        def initialize(name)
          @name = name
        end

        ##
        # Define nanite settings
        # @param [Numeric] max_number defaults to 4
        # @param [Boolean] keep_alive defaults to false
        # @param [Object] using
        #
        def nanites(max_number: 4, keep_alive: false, using:)
          raise NanoMind::Errors::DSLError, "'#{using}' isn't a nanite template" unless
              using <= NanoMind::Core::Nanites::Template

          @max_number = max_number
          @keep_alive = keep_alive
          @nanite_template = using
        rescue ArgumentError => e
          raise NanoMind::Errors::DSLError, e
        end

        ##
        # Set the output stack
        # @param [NanoMind::Core::Stacks::OutputStack] to
        # @raise [NanoMind::Errors::DSLError]
        #
        def output(to:)
          raise NanoMind::Errors::DSLError, "Can't set output stack to '#{to}'" unless
              to.class <= NanoMind::Core::Stacks::OutputStack

          @output_stack = to
        end

        ##
        # Set the input stack
        # @param [NanoMind::Core::Stacks::InputStack] from
        # @raise [NanoMind::Errors::DSLError]
        #
        def input(from:)
          raise NanoMind::Errors::DSLError, "Can't set input stack to '#{from}'" unless
              from.class <= NanoMind::Core::Stacks::InputStack

          @input_stack = from
        end

        ##
        # Register event handlers
        # @param [Object] handler
        # @param [Object] to
        # @raise [NanoMind::Errors::DSLError]
        #
        def register(handler:, to:)
          raise NanoMind::Errors::DSLError, "Can't use event(s) '#{to}'" unless to.is_a?(Array) || to.is_a?(Symbol)

          to = [to] if to.is_a?(Symbol)
          handler = [handler] unless handler.is_a?(Array)

          _check_events to

          # Initialize handler registration
          @evt_handlers ||= {}

          # Add evt/handler pairs
          to.each do |evt|
            @evt_handlers[evt] = handler
          end
        end

        private

        # Helper for checking if given event names are valid
        def _check_events(events)
          events.each do |evt|
            raise NanoMind::Errors::DSLError, "Unknown event '#{evt}'" unless
                NanoMind::Core::Layers::Events::EVENTS.include?(evt)
          end
        end
      end
    end
  end
end
