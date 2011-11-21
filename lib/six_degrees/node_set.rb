module SixDegrees
  class NodeSet
    include Enumerable

    def initialize(names)
      @nodes = []
      names.each { |name| add_node(name) }
    end

    def add_node(name)
      @nodes << Node.new(name)
      @nodes.sort!
    end

    def each(&block)
      @nodes.each do |node|
        yield(node)
      end
    end

    def length
      @nodes.length
    end
  end

  class Node
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def <=>(other)
      name.downcase <=> other.name.downcase
    end
  end
end
