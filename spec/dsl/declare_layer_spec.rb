# frozen_string_literal: true

require 'spec_helper'

describe 'Layer declaration' do
  let(:declaration) do
    NanoMind::DSL::Declaration::Layer.new :foo_bar
  end

  context 'required methods exist' do
    it 'responds to #nanites' do
      expect(declaration.respond_to?(:nanites)).to be_truthy
    end

    it 'responds to #output' do
      expect(declaration.respond_to?(:output)).to be_truthy
    end

    it 'responds to #input' do
      expect(declaration.respond_to?(:input)).to be_truthy
    end

    it 'responds to #register' do
      expect(declaration.respond_to?(:register)).to be_truthy
    end
  end

  context 'setting name' do
    it 'has name set in construction' do
      expect(declaration.name).to eq :foo_bar
    end
  end

  context 'setting nanites' do
    context 'method calls' do
      it 'accepts required parameter' do
        expect { declaration.nanites(using: NanoMind::Core::Nanites::Template) }.to_not raise_error
      end

      it 'accepts only Template classes for parameter "using"' do
        expect { declaration.nanites(using: 'some-value') }.to raise_error NanoMind::Errors::DSLError
      end

      it 'accepts optional parameter "max_number"' do
        expect { declaration.nanites(max_number: 4, using: NanoMind::Core::Nanites::Template) }.to_not raise_error
      end

      it 'accepts optional parameter "keep_alive"' do
        expect { declaration.nanites(keep_alive: true, using: NanoMind::Core::Nanites::Template) }.to_not raise_error
      end
    end

    context 'attributes set correctly' do
      before do
        @obj = declaration
        @obj.nanites(max_number: 14, keep_alive: true, using: NanoMind::Core::Nanites::Template)
      end

      it 'has "max_number" set to 14' do
        expect(@obj.max_number).to eq 14
      end

      it 'has "keep_alive" set to true' do
        expect(@obj.keep_alive).to be_truthy
      end

      it 'has "nanite_template" set to Object' do
        expect(@obj.nanite_template).to eq NanoMind::Core::Nanites::Template
      end
    end

    context 'default values are set correctly' do
      before do
        @obj = declaration
        @obj.nanites(using: NanoMind::Core::Nanites::Template)
      end

      it 'has "max_number" set to 4' do
        expect(@obj.max_number).to eq 4
      end

      it 'has "keep_alive" set to false' do
        expect(@obj.keep_alive).to be_falsey
      end
    end
  end

  context 'setting output' do
    context 'method call' do
      it 'accepts required parameter' do
        expect { declaration.output(to: NanoMind::Core::Stacks::OutputStack.new) }.to_not raise_error
      end

      it 'accepts only OutputStack for required parameter' do
        expect { declaration.output(to: String.new) }.to raise_error NanoMind::Errors::DSLError
      end
    end

    context 'attributes set correctly' do
      it 'has output set to "stack"' do
        obj = declaration
        stack = NanoMind::Core::Stacks::OutputStack.new

        obj.output(to: stack)

        expect(obj.output_stack).to eq stack
      end

      it 'has no default value' do
        expect(declaration.output_stack).to be_nil
      end
    end
  end

  context 'setting input' do
    context 'method call' do
      it 'accepts required parameter' do
        expect { declaration.input(from: NanoMind::Core::Stacks::InputStack.new) }.to_not raise_error
      end

      it 'accepts only InputStack for required parameter' do
        expect { declaration.input(from: String.new) }.to raise_error NanoMind::Errors::DSLError
      end
    end

    context 'attributes set correctly' do
      it 'has input set to "stack"' do
        obj = declaration
        stack = NanoMind::Core::Stacks::InputStack.new

        obj.input(from: stack)

        expect(obj.input_stack).to eq stack
      end

      it 'has no default value' do
        expect(declaration.input_stack).to be_nil
      end
    end
  end

  context 'register event handlers' do
    context 'method call' do
      it 'accepts required parameters' do
        expect { declaration.register(handler: proc {}, to: :after_creation) }.to_not raise_error
      end

      it 'accepts an array for events' do
        expect { declaration.register(handler: proc {}, to: :after_creation) }.to_not raise_error
      end

      it 'accepts an array for handlers' do
        expect { declaration.register(handler: [proc {}], to: %i[after_creation before_nanite_creation]) }.to_not raise_error
      end

      it 'only accepts valid events' do
        expect { declaration.register(handler: proc {}, to: :unknown) }.to raise_error NanoMind::Errors::DSLError
      end

      it 'only accepts functions as handlers' do
        # TODO: Check for function, not object
        expect { declaration.register(handler: Object, to: :after_creation) }.to_not raise_error
      end
    end

    context 'handlers set correctly' do
      before do
        @obj = declaration
      end

      it 'has 1 handler for event :before_nanite_creation' do
        @obj.register(handler: proc {}, to: :before_nanite_creation)

        expect(@obj.evt_handlers.key?(:before_nanite_creation)).to be_truthy
        expect(@obj.evt_handlers[:before_nanite_creation].count).to eq 1
      end

      it 'has 2 handlers for event ":after_creation"' do
        @obj.register(handler: [proc {}, proc {}], to: :after_creation)

        expect(@obj.evt_handlers.key?(:after_creation)).to be_truthy
        expect(@obj.evt_handlers[:after_creation].count).to eq 2
      end

      it 'has 2 handlers for events ":after_creation" and ":before_nanite_creation"' do
        @obj.register(handler: [proc {}, proc {}], to: %i[after_creation before_nanite_creation])

        expect(@obj.evt_handlers.key?(:after_creation)).to be_truthy
        expect(@obj.evt_handlers.key?(:before_nanite_creation)).to be_truthy
        expect(@obj.evt_handlers[:after_creation].count).to eq 2
        expect(@obj.evt_handlers[:before_nanite_creation].count).to eq 2
      end
    end
  end
end
