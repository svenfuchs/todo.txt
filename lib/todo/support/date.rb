require 'date'

module Todo
  module Support
    class Date
      NUMS   = [:one, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten]
      MONTHS = [:jan, :feb, :mar, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec]
      WDAYS  = [:sun, :mon, :tue, :wed, :thu, :fri, :sat]
      FORMAT = '%Y-%m-%d'
      MSGS   = { unknown: 'Unrecognized identifier: %s' }

      SEP    = '(?: |_|\-|\.)'
      AGO    = /^(\d+|#{NUMS.join('|')})#{SEP}(days?|weeks?|months?|years?)#{SEP}ago$/
      LAST   = /^last#{SEP}(#{MONTHS.join('|')}|#{WDAYS.join('|')})/
      DATE   = /\d{4}-\d{2}-\d{2}/

      attr_reader :date

      def initialize(date = ::Date.today)
        @date = date.is_a?(String) ? Time.parse(date).to_date : date.to_date
      end

      def format(str, opts = {})
        apply(str).strftime(opts[:format] || FORMAT)
      end

      private

        def apply(str)
          if str =~ DATE
            Time.parse(str).to_date
          elsif respond_to?(str, true)
            send(str)
          elsif str =~ AGO
            ago(singularize($2).to_sym, to_number($1))
          elsif str =~ LAST
            last($1)
          else
            fail MSGS[:unknown] % str
          end
        end

        def today
          date
        end

        def yesterday
          ago(:day, 1)
        end

        def ago(type, num)
          type, num = :day, num * 7 if type == :week
          1.upto(num).inject(date) { |date, _| date.send(:"prev_#{type}") }
        end

        def last(str)
          key = str.to_s.downcase[0, 3].to_sym
          last_wday(key) || last_month(key) || fail(MSGS[:unknown] % str)
        end

        def last_month(key)
          return unless num = MONTHS.index(key)
          date = self.date.prev_month
          date = date.prev_month until date.month == num + 1
          date
        end

        def last_wday(key)
          return unless num = WDAYS.index(key)
          date = self.date.prev_day
          date = date.prev_day until date.wday == num
          date
        end

        def wday_ix(day)
          WDAYS.index(day.to_s.downcase[0, 3].to_sym)
        end

        def to_number(str)
          ix = NUMS.index(str.to_sym)
          ix ? ix + 1 : str.to_i
        end

        def pluralize(str)
          "#{str}s".sub(/ss$/, 's')
        end

        def singularize(str)
          str.sub(/s$/, '')
        end
    end
  end
end
