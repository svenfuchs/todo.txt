module Todo
  class Item < Struct.new(:line)
    STATUS  = /^(#{STATUSES.values.join('|')}){1}\s*/
    DONE    = /^#{STATUSES[:done]}{1}/
    DATE    = /\s*done:(\d{4}-\d{2}-\d{2})/
    TAG     = /\s*([^\s]+):([^\s]+)/
    PROJECT = /\s*\+([\w\-]+)/

    def done?
      status == :done
    end

    def status
      @status ||= STATUSES.invert[line.match(STATUS) && $1] || raise("Unknown status")
    end

    def text
      @text = line.sub(STATUS, '').gsub(TAG, '').strip
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

    def to_s
      [STATUSES[status], text, *to_pairs(tags)].compact.join(' ')
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
