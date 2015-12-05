require 'todo/cmds/base'

module Todo
  module Cmds
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
