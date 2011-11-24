module SixDegrees
  class NodeSet
    include Enumerable

    def initialize(names)
      @nodes = []
      names.each { |name| add_node(name) }
    end

    def add_node(name)
      @nodes << name
      @nodes.sort!
    end

		def find(name)
			@nodes[@nodes.index(name)]
		end

    def each(&block)
      @nodes.each do |node|
        yield(node)
      end
    end
  end
end
