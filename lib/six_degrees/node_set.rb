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

		def find_by_name(name)
			@nodes[@nodes.index(name)]
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

		# To keep NodeSets easier to debug
		def to_s
			name
		end

		# To allow use to find elements easily using built in methods such
		# as index on the containing collection, using just the name.
		def ==(other)
			@name == other.to_s
		end

		# Sort alphabetically by default
    def <=>(other)
      name.downcase <=> other.name.downcase
    end
  end
end
