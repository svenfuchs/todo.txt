module Todo
  module Helpers
    module Hash
      module Format
        def to_pairs(hash, separator = '=')
          hash.map { |key, value| [key, value].join(separator) }
        end

        extend self
      end
    end
  end
end
