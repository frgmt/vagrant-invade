module VagrantPlugins
  module Invade
    module Validator

      autoload :Ruleset, 'vagrant-invade/validator/ruleset'
      autoload :Type, 'vagrant-invade/validator/type'

      class Validator
        attr_accessor :env, :ruleset, :depth

        def initialize(env)
          @env = env
          @ruleset = Ruleset::YAMLRuleset.new(env)
          @depth = 0
          @logger = Log4r::Logger.new('vagrant::invade::validator::vagrant')
        end

        def validate(part_name, value_name, value_data)

          # Set depth before build
          @ruleset.depth = @depth

          # Build rules
          @ruleset.build(part_name, value_name)

          unless @ruleset.rules.nil?

            # Fill with defaults
            @ruleset.rules.each do |rule_key, rule_value|
              unless rule_value['default'] == 'nil'
                value_data[rule_key] = rule_value['default'] if value_data[rule_key].nil?
              end
            end

            # Finally build type validator and validate the options
            value_data.each do |option_name, option_value|
              if @ruleset.valid?(option_name)
                type_validator = init_type_validator(option_name, option_value)
                value_data[option_name] = type_validator.validate
              end
            end

          end

          value_data
        end

        private

        def init_type_validator(option_name, option_value)

          begin

            # Build validator class string
            validator_type_class_name = @ruleset.rules[option_name]['type'] + 'Validator'

            # Return class dynamically with class name string
            return VagrantPlugins::Invade::Validator::Type.const_get(
                validator_type_class_name
            ).new(
                option_value,
                option_name,
                @ruleset.rules[option_name]['default'],
                @env
            )

          rescue StandardError => e
            @logger.error e
            fail e
          end
        end
      end
    end
  end
end
