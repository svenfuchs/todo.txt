require 'optparse'

module Todo
  module Support
    module OptionsParser
      def opt(*args, &block)
        rules << [args, block]
      end

      def parse(args)
        opts = {}
        args = parser(opts).parse(args)
        [args, opts]
      end

      private

        def rules
          @rules ||= (superclass.instance_variable_get(:@rules) || []).dup
        end

        def parser(opts)
          OptionParser.new do |parser|
            rules.each do |args, block|
              parser.on(*args) { |value| block.call(opts, value.strip) }
            end
          end
        end
    end
  end
end
