require 'todo/store'

module Todo
  class Cli
    module Cmds
      class Base < Struct.new(:args, :opts)
        def text
          args.join(' ') if args.any?
        end

        def list
          @list ||= Todo::List.new(input)
        end

        def input
          @input ||= file? ? file.lines : STDIN.readlines
        end

        def output
          file? ? file.write(list.to_s) : puts(list.to_s)
        end

        def file?
          !!opts[:file]
        end

        def file
          @file ||= File.new(opts[:file])
        end
      end

      class List < Base
        def run
          items = list.items
          items = items.select { |item| opts[:status].to_sym == item.status } if opts[:status]
          items = items.select { |item| opts[:since] <= item.done_date.to_s } if opts[:since]
          items = items.sort_by(&:done_date)
          puts items.map { |item| [item.done_date, item.text].join(' ') }
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
          raise 'No item given' unless text
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

      class Archive < Base
        def run
          write(lines)
          list.lines.delete_if { |line| lines.include?(line) }
          output
        end

        def write(lines)
          ::File.open(archive_filename, 'a+') do |f|
            f << lines.reject { |line| archived.include?(line) }.join("\n")
          end
        end

        def lines
          @lines ||= items.map { |item| item.line }
        end

        def items
          items = list.items.select(&:done?)
          items = items.select { |item| item.tags[:done].to_s < before }
          items.reverse
        end

        def archived
          @archived ||= ::File.exists?(archive_filename) ? ::File.read(archive_filename).split("\n") : []
        end

        def archive_filename
          ::File.expand_path('../archive.txt', opts[:file].to_s)
        end

        def before
          opts[:before] || DATES[:two_weeks_ago]
        end
      end

      class Push < Base
        def run
          store.push(items.map { |item| item.to_s(:text, :tags, :id) })
        end

        def items
          items = list.items.select(&:done?)
          items = items.select { |item| item.tags[:done].to_s >= since }
          items.reject { |item| store.known?(item) }
        end

        def store
          @store ||= Store.new(since: since, team: ENV['IDONETHIS_TEAM'], username: ENV['IDONETHIS_USERNAME'], token: ENV['IDONETHIS_TOKEN'])
        end

        def since
          opts[:since] || DATES[:yesterday]
        end
      end
    end
  end
end
