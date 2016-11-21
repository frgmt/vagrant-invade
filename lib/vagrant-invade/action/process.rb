module VagrantPlugins
  module Invade
    module Action

      include Vagrant::Action::Builtin

      class Process

        def initialize(app, env)
          @app = app
          @env = env

          @validator = VagrantPlugins::Invade::Validator::Validator.new(env)
          @generator = VagrantPlugins::Invade::Generator::Generator.new(env)

          @logger = Log4r::Logger.new('vagrant::invade::action::validate')
        end

        def call(env)
          config  = env[:invade]
          quiet   = @env[:invade_validate_quiet]
          generate = @env[:invade_generate]

          invade_machine = Hash.new
          invade_machine_part = Hash.new
          invade_vagrantfile = Hash.new

          ###############################################################
          # Validate the settings and set default variables if needed
          ###############################################################

          # Remove empty Hashes
          config.delete_blank

          config.each do |config_key, config_data|

            if config_key == 'machines'

              # Iterate over machine configurations
              config_data.each_with_index do |(machine, machine_part), _|

                # Iterate over each machine part configuration
                machine_part.each do |machine_part_name, machine_part_data|
                  @env[:ui].info("\n[Invade][Machine: #{machine.upcase}]: Validating #{machine_part_name.upcase} part...") unless quiet

                  # Is nested synced_folder, network, provision, or plugin part hash
                  if machine_part_data.depth > 1

                    invade_machine_part[machine_part_name] = ''
                    machine_part_data.each do |value_name, value_data|

                      # Output info message
                      info_message = "\t#{machine_part_name.split('_').collect(&:capitalize).join}: #{value_name}"
                      @env[:ui].info(info_message) unless @env[:invade_validate_quiet]

                      validated_data = validate(machine_part_name, value_name, value_data, machine_part_data.depth)
                      invade_machine_part[machine_part_name].concat(
                          generate(
                              machine_name: machine,
                              part: machine_part_name,
                              part_type: value_name,
                              data: validated_data,
                              generator_type: Invade::Generator::Type::MACHINE_NESTED_PART
                        )
                      ) if generate
                    end
                  else # Is VM, or SSH part
                    validated_data = validate('Machine', machine_part_name, machine_part_data, machine_part_data.depth)
                    invade_machine_part[machine_part_name] = generate(
                        machine_name: machine,
                        part_type: machine_part_name,
                        data: validated_data,
                        generator_type: Invade::Generator::Type::MACHINE_PART
                    ) if generate
                  end
                end

                invade_machine[machine] = generate(
                    machine_name: machine,
                    data: invade_machine_part,
                    generator_type: Invade::Generator::Type::MACHINE
                )

              end

              invade_vagrantfile['machines'] = invade_machine
              @env[:ui].success "\n[Invade]: Processed #{config_data.count} machine(s)."

            else

              # Info message
              @env[:ui].info("\n[Invade]: Validating #{config_key.upcase} part...") unless quiet

              validated_data = validate(config_key, config_key, config_data, config_data.depth)
              invade_vagrantfile[config_key] = generate(
                  part_type: config_key,
                  data: validated_data,
                  generator_type: Invade::Generator::Type::VAGRANT_PART
              ) if generate

            end

          end

          @env[:invade]['vagrantfile'] = generate(
              data: invade_vagrantfile,
              generator_type: Invade::Generator::Type::VAGRANTFILE
          ) if generate

          @env[:invade].delete('machines')

          @app.call(env)
        end

        def validate(part_name, value_name, value_data, depth)
          @validator.depth = depth
          @validator.validate(part_name, value_name, value_data)
        end

        def generate(machine_name: nil, part: nil, part_type: nil, data: nil, generator_type: nil)
          @generator.type = generator_type
          @generator.generate(
              machine: machine_name,
              part: part,
              type: part_type,
              data: data
          )
        end

      end
    end
  end
end
