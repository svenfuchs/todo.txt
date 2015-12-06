module Todo
  module Helpers
    module Hash
      module Compact
        def compact(hash)
          hash.reject { |key, value| value.nil? }
        end

        extend self
      end
    end
  end
end
