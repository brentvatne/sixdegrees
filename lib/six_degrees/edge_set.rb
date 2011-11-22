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

    # Returns all nodes connected to
    def nodes_connected_to(source)
      reduce_edges do |all_connected_nodes, edges_at_order_n|
        all_connected_nodes << edges_at_order_n[source]
      end
    end

    # Next step: make this get a 'uniq' list of sources at every order
    def sources
      reduce_edges do |all_sources, edges_at_order_n|
        all_sources << edges_at_order_n.keys
      end
    end

    def reduce_edges(&block)
      edges.values.inject([]) do |total, edges_at_order_n|
        yield(total, edges_at_order_n)
      end.flatten.uniq
    end

    # Then, loop over the nth for the number of orders we want, write
    # 3rd order acceptance test, and try on quiz data.
    # Once that works, refactor.

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
