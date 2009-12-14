module Inploy
  module Templates
    module Sinatra
      def after_update_code
        bundle_gems
        restart_server
      end
    end
  end
end
