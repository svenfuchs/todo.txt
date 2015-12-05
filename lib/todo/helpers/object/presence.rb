module Todo
  module Helpers
    module Object
      module Presence
        def present?(obj)
          case obj
          when NilClass, FalseClass
            false
          when TrueClass, Symbol, Numeric
            true
          when ::String, ::Array, ::Hash
            !obj.empty?
          else
            fail "Unexpected object type #{obj.inspect}"
          end
        end

        def blank?(obj)
          not present?(obj)
        end

        extend self
      end
    end
  end
end
