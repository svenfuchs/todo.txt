module Todo
  class Item < Struct.new(:list, :line)
    PARTS   = [:status, :text, :tags, :id]
    STATUS  = /^(#{STATUSES.values.join('|')}){1}\s*/
    DONE    = /^#{STATUSES[:done]}{1}/
    DATE    = /\s*done:(\d{4}-\d{2}-\d{2})/
    ID      = /\s*\[(\d+)\]/
    TAG     = /\s*([^\s]+):([^\s]+)/
    PROJECT = /\s*\+([\w\-]+)/

    def done?
      status == :done
    end

    def status
      @status ||= STATUSES.invert[line.match(STATUS) && $1] || raise("Unknown status")
    end

    def id
      @id ||= line =~ ID && $1.to_i
    end

    def text
      @text = line.sub(STATUS, '').gsub(ID, '').gsub(TAG, '').strip
    end

    def done_date
      tags[:done].to_s
    end

    def tags
      @tags ||= Hash[line.scan(TAG).map { |key, value| [key.to_sym, value] }]
    end

    def project
      @project ||= line.scan(PROJECT).flatten.first # TODO?
    end

    def toggle
      status == :done ? pend : done
    end

    def done
      @status = :done
      tags[:done] = today
    end

    def pend
      @status = :pend
      tags.delete(:done)
    end
    alias pending pend


    def to_s(*parts)
      format(*parts.empty? ? PARTS : parts)
    end

    def format(*parts)
      result = parts.inject([]) do |result, part|
        result << case part
        when :status then STATUSES[status]
        when :text   then text
        when :tags   then to_pairs(tags)
        when :id     then "[#{id || list.next_id}]"
        end
        result
      end
      result.flatten.compact.join(' ')
    end

    def <=>(other)
      status <=> other.status
    end

    private

      def today
        Time.now.strftime('%Y-%m-%d')
      end

      def to_pairs(hash)
        hash.map { |key, value| [key, value].join(':') }
      end
  end
end
