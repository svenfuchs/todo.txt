module Todo
  module Helpers
    module String
      module Camelize
        def camelize(string)
          string.to_s.
            sub(/^[a-z\d]*/) { $&.capitalize }.
            gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.
            gsub('/', '::')
        end

        extend self
      end
    end
  end
end
