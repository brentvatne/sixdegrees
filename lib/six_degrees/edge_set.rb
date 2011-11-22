module SixDegrees
  # The job of this class is to manage logic related to connections between nodes
  class EdgeSet
    attr_reader :edges

    # Initializes from a collection of edges if they are passed in,
    # otherwise, initializes an empty collection
    def initialize(edge_set = false)
      @edges  = Hash.new do |o_hash, order|
        o_hash[order] = Hash.new { |s_hash, source| s_hash[source] = [] }
      end
      edge_set.keys.each { |key| @edges[key] = edge_set[key] } if edge_set
    end

    def add(source, target, order)
      edges[order][source] << target if target != source
    end

    # Returns all nodes that are connected at order n
    def at_order(order)
      EdgeSet.new({ order => edges.fetch(order) })
    end

    # Returns all edges that start at the given source name
    def starting_at(source)

    end

    # Returns all edges that end at the given target name
    def ending_at(target)

    end

    def from(source)
      edges[1].fetch(source)
    end

    def sources
      edges[1].keys
    end

    def endpoints
    end

    # Returns all edges without concern for the order
    def ignore_order

    end

    def ==(other)
      edges == other.edges
    end

    def connected_at_order?(source, target, order)
      return false unless edges.keys.include?(order)
      !!(@edges[order][source].include?(target))
    end

    # If no order is passed, can iterate through all
    def connected?(source, target, order = :all)
      return true if source == target

      if order == :all
        edges.keys.each { |order| return true if connected_at_order?(source, target, order) }
        false
      else
        connected_at_order?(source, target, order)
      end
    end
  end
end
