require 'todo/store'

module Todo
  class Cli
    module Cmds
      class Base < Struct.new(:args, :opts)
        def text
          args.join(' ')
        end

        def list
          @list ||= List.new(input)
        end

        def input
          file? ? file.lines : args
        end

        def output
          # string = View.new(list.items).to_s
          file? ? file.write(list.to_s) : puts(list.to_s)
        end

        def file?
          opts[:file]
        end

        def file
          @file ||= File.new(opts[:file])
        end
      end

      class Pend < Base
        def run
          list.pend(text)
          output
        end
      end

      class Done < Base
        def run
          list.done(text)
          output
        end
      end

      class Toggle < Base
        def run
          list.toggle(text)
          output
        end
      end

      class Push < Base
        def run
          items = list.items.select(&:done?)
          items = items.reject { |item| store.ids.include?(item.id) }
          store.push(items.map { |item| [item.text, "id:#{item.id}"].join(' ') })
        end

        def store
          @store ||= Store.new(since: since, team: ENV['IDONETHIS_TEAM'], username: ENV['IDONETHIS_USERNAME'], token: ENV['IDONETHIS_TOKEN'])
        end

        def since
          @since ||= Chronic.parse(opts[:since] || '2015-11-12').to_date
        end
      end
    end
  end
end
