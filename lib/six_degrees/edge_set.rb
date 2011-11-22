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

    # Next step: make this get ALL edges connected to the source
    def from(source)
      edges[1].fetch(source)
    end

    # Next step: make this get a 'uniq' list of sources at every order
    def sources
      edges[1].keys
    end

    # Then, loop over the nth for the number of orders we want, write
    # 3rd order acceptance test, and try on quiz data.
    # Once that works, refactor.

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

    # If no order is passed, iterate through all
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
