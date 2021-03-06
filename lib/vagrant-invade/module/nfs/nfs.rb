module VagrantPlugins
  module Invade
    module InvadeModule

      class Nfs < InvadeModule

        attr_reader :result
        attr_accessor :nfs_data

        def initialize(nfs_data, result: nil)
          @nfs_data = nfs_data
          @result = result
        end

        def build
          b = binding

          begin

            # Values for nfs part
            functional = @nfs_data['functional']
            @nfs_data['map_uid'] ? map_uid = @nfs_data['map_uid'] : map_uid = Process.uid
            @nfs_data['map_gid'] ? map_gid = @nfs_data['map_gid'] : map_gid = Process.gid
            verify_installed = @nfs_data['verify_installed']

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
