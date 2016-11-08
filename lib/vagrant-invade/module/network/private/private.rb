module VagrantPlugins
  module Invade
    module InvadeModule
      module Network

        class Private < InvadeModule

          require 'ipaddr'

          attr_reader :result
          attr_accessor :machine_name, :private_network_data

          def initialize(machine_name, private_network_data, result: nil)
            @machine_name = machine_name
            @private_network_data = private_network_data
            @result = result
          end

          def build
            b = binding
            template_file = "#{TEMPLATE_PATH}/network/private_network.erb"

            # Delete all nil keys
            @private_network_data = self.delete_blank @private_network_data

            ip = @private_network_data['ip']

            # Handle IP address exceptions
            if ip

              @private_network_data.delete('type')

              # Netmask only makes sense if IP is ipv6
              if @private_network_data['netmask'] && !IPAddr.new(ip).ipv6?
                @private_network_data.delete('netmask')
              end
            end

            begin
              # Get machine name
              machine_name = @machine_name
              network_data = @private_network_data

              eruby = Erubis::Eruby.new(File.read(template_file))
              @result = eruby.result b
            rescue TypeError, SyntaxError, SystemCallError => e
              raise(e)
            end
          end

          def delete_blank(hash)
            hash.delete_if do |k, v|
              (v.respond_to?(:empty?) ? v.empty? : !v) or v.instance_of?(Hash) && v.delete_blank.empty?
            end
          end

        end

      end
    end
  end
end