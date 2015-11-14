module Todo
  class File < Struct.new(:name)
    def lines
      @lines ||= ::File.read(name).split("\n") #.select { |line| line =~ LINE }
    end

    def write(string)
      ::File.open(name, 'w+') { |f| f.write(string) }
    end
  end
end
