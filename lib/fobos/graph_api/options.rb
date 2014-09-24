module Fobos
  module GraphAPI
    class Options
      def self.map_options_to_params(options)
        options.map {|k,v| "#{k}=#{v.kind_of?(Array) ? v.join(',') : v}" }.join('&')
      end
    end
  end
end