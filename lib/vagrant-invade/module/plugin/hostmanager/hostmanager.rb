module VagrantPlugins
  module Invade
    module InvadeModule
      module Plugin

        class Hostmanager < InvadeModule

          require 'vagrant'

          attr_reader :result
          attr_accessor :machine_name, :ui, :hostmanager_data

          def initialize(machine_name, hostmanager_data, result: nil)
            @machine_name = machine_name
            @hostmanager_data = hostmanager_data
            @result = result
          end

          def build

            b = binding

            begin

              # Get machine name
              machine_name = @machine_name

              # Values for hostmanager section
              enabled = @hostmanager_data['enabled']
              manage_host = @hostmanager_data['manage_host']
              ignore_private_ip = @hostmanager_data['ignore_private_ip']
              include_offline =@hostmanager_data['include_offline']
              aliases = @hostmanager_data['aliases']

              eruby = Erubis::Eruby.new(File.read(self.get_template_path(__FILE__)))
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
