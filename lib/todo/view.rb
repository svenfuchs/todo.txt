require 'todo/helpers/string'

module Todo
  class View < Struct.new(:items)
    include Helpers::String

    FORMAT = {
      project: "\n# %s\n"
    }

    def to_s
      projects.join("\n").strip
    end

    def projects
      by_project.map do |project, items|
        lines = [FORMAT[:project] % camelize(project || 'No project')]
        lines += items.sort.map(&:to_s)
        lines
      end
    end

    def format(project, items)
    end

    def by_project
      items.inject({}) do |result, item|
        result[item.project] ||= []
        result[item.project] << item.to_s
        result
      end
    end
  end
end
