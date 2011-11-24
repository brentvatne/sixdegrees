module SixDegrees
  # Manages logic related to connections between nodes, also known as edges
  class EdgeSet
    # A two-dimensional Hash edges[order][source_node] = [connected_node_1, connected_node_2]
    attr_reader :edges

    # Initializes a new set of edges, and if another set is passed in, it is copied
    # into the new collection.
    #
    # edge_set - An EdgeSet instance, default is false
    def initialize(edge_set = false)
      @edges  = Hash.new do |order_hash, order|
        order_hash[order] = Hash.new { |source_node_hash, source| source_node_hash[source] = [] }
      end

      edge_set.keys.each { |key| @edges[key] = edge_set[key] } if edge_set
    end

    # Creates a new edge
    #
    # source - A String node name
    # target - A String node
    # order  - An Integer order
    #
    # Returns the EdgeSet instance
    def add(source, target, order)
      edges[order][source].push(target).sort!.uniq! if target != source
      self
    end

    # Selects orders at order n
    # Returns a new EdgeSet instance
    def at_order(order)
      if edges.has_key?(order)
        EdgeSet.new({ order => edges.fetch(order) })
      else
        EdgeSet.new
      end
    end

    # Iterates over edges based on the order
    # Returns the EdgeSet instance
    def each_order
      @edges.values.each { |order| yield(order) }
      self
    end

    # Selects nodes that are connected at an endpoint to a given node
    # Chainable with at_order
    #
    # source_node - A String node name
    #
    # Returns an Array of Strings representing nodes
    def nodes_connected_to(source_node)
      reduce_edges do |all_connected_nodes, edges_at_order_n|
        all_connected_nodes << edges_at_order_n[source_node]
      end
    end


    # Selects all nodes that act as the start point for an edge
    # Chainable with at_order
    #
    # Returns an Array of Strings representing nodes
    def sources
      reduce_edges do |all_sources, edges_at_order_n|
        all_sources << edges_at_order_n.keys
      end
    end

    # Convenience method to subset edges
    #
    # Accepts a block
    #
    # Returns an Array, the contents of the Array depend on the block
    def reduce_edges
      edges.values.inject([]) do |total, edges_at_order_n|
        yield(total, edges_at_order_n)
      end.flatten.uniq.sort
    end

    # Determines whether an edge exists from the source to the target
    # at a given order (all by default).
    #
    # source - A String node name
    # target - A String node name
    # order  - The order to search for the connection at
    #
    # Returns true if connected, false if not connected
    def connected?(source, target, order = :all)
      return true if source == target

      if order == :all
        edges.keys.each { |order| return true if connected_at_order?(source, target, order) }
        false
      else
        connected_at_order?(source, target, order)
      end
    end

    # Determines whether an edge exists from the source to the target
    # A convenience method to keep connected? readable
    #
    # Returns true if connected, false if not connected
    def connected_at_order?(source, target, order)
      return false unless edges.keys.include?(order)
      !!(@edges[order][source].include?(target))
    end
  end
end
