module VagrantPlugins
  module Invade
    module Builder

      require 'erubis'

      class Box

        attr_reader :result
        attr_accessor :machine_name, :options

        def initialize(machine_name, options, result: nil)
          @machine_name = machine_name
          @options  = options
          @result   = result
        end

        def build
          b = binding
          template_file = "#{TEMPLATE_PATH}/box/box.erb"

          begin

            # Get machine name
            machine_name = @machine_name

            # Values for box section
            name  = @options['name']
            url   = @options['url']

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
