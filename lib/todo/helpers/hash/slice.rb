module Todo
  module Helpers
    module Hash
      module Slice
        def slice(hash, *keys)
          hash.select { |key, value| keys.include?(key) }
        end

        def except(hash, *keys)
          hash.reject { |key, value| keys.include?(key) }
        end

        extend self
      end
    end
  end
end
