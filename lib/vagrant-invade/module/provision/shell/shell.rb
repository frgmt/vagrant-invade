module VagrantPlugins
  module Invade
    module Module
      module Provision

        class Shell <  Module

          attr_reader :result
          attr_accessor :machine_name, :name, :shell_data

          def initialize(machine_name, name, shell_data, result: nil)
            @machine_name = machine_name
            @shell_name = name
            @shell_data  = shell_data
            @result   = result
          end

          def build
            b = binding
            template_file = "#{TEMPLATE_PATH}/provision/shell.erb"

            begin

              # Get machine name
              machine_name = @machine_name

              # Values for shell provision section
              name = @shell_name
              path = @shell_data['path']
              binary = @shell_data['binary']
              privileged = @shell_data['privileged']

              eruby = Erubis::Eruby.new(File.read(template_file))
              @result = eruby.result b
            rescue TypeError, SyntaxError, SystemCallError => e
              raise(e)
            end
          end
        end

      end
    end
  end
end
