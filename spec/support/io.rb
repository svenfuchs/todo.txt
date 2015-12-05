require 'stringio'

module Support
  class Io < StringIO
    def readlines
      string.split("\n")
    end
  end
end
