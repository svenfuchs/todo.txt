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

      DATES = {
        two_weeks_ago: (Time.now - 60 * 60 * 24 * 14).strftime('%Y-%m-%d'),
        yesterday:     (Time.now - 60 * 60 * 24).strftime('%Y-%m-%d'),
        today:         Time.now.strftime('%Y-%m-%d')
      }

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
          DATES[opts[:before]] || opts[:before] || DATES[:two_weeks_ago]
        end
      end

      class Push < Base
        def run
          store.push(items.map(&:text))
        end

        def items
          items = list.items.select(&:done?)
          items = items.select { |item| item.tags[:done].to_s >= since }
          items.reject { |item| store.items.map(&:text).include?(item.text) }
        end

        def store
          @store ||= Store.new(since: since, team: ENV['IDONETHIS_TEAM'], username: ENV['IDONETHIS_USERNAME'], token: ENV['IDONETHIS_TOKEN'])
        end

        def since
          DATES[opts[:since]] || opts[:since] || DATES[:yesterday]
        end
      end
    end
  end
end
