module SixDegrees
  # Manages logic related to connections between nodes, also known as edges
  class EdgeSet
    # A two-dimensional Hash edges[order][source_node] = [connected_node_1, connected_node_2]
    attr_reader :edges

    # Public: Initializes a new set of edges, and if another set is passed in, it is copied
    # into the new collection.
    #
    # edges_set - The 'edges' instance variable from another EdgeSet instance
    def initialize(edges_subset = false)
      @edges  = Hash.new do |order_hash, order|
        order_hash[order] = Hash.new { |source_node_hash, source| source_node_hash[source] = [] }
      end

      edges_subset.keys.each { |key| @edges[key] = edges_subset[key] } if edges_subset
    end

    # Public: Creates a new edge
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

    # Public: Selects orders at order n
    #
    # order - An Integer order
    #
    # Returns a new EdgeSet instance
    def at_order(order)
      if edges.has_key?(order)
        EdgeSet.new({ order => edges.fetch(order) })
      else
        EdgeSet.new
      end
    end

    # Public: Determines whether an edge exists from the source to the target
    # at a given order (all by default).
    #
    # source - A String node name
    # target - A String node name
    # order  - The Integer order to search for the connection at (optional,
    #          default => :all)
    #
    # Returns true if connected, false if not connected
    def connected?(source, target, order = :all)
      return true if source == target

      if order == :all
        edges.keys.each { |order| return true if connected?(source, target, order) }
        false
      else
        return false unless edges.keys.include?(order)
        edges[order][source].include?(target)
      end
    end

    # Public: Selects nodes connected to the given node, as an endpoint. This
    # means if a relationship brent -> ana exists, ana would be selected if
    # brent is passed in; brent would not be selected if ana were to be the
    # source. Chainable with at_order
    #
    # source_node - A String node name
    #
    # Yields a node (String)
    #
    # Returns an Array of Strings representing nodes
    def nodes_connected_to(source_node)
      reduce_edges do |all_connected_nodes, edges_at_order_n|
        all_connected_nodes << edges_at_order_n[source_node]
      end
    end

    # Public: Selects all nodes that act as the start point for an edge
    # Chainable with at_order
    #
    # Returns an Array of Strings representing nodes
    def sources
      reduce_edges do |all_sources, edges_at_order_n|
        all_sources << edges_at_order_n.keys
      end
    end

    # Public: Iterates over edges based on the order
    #
    # Yields the edges hash at each order
    #
    # Returns the EdgeSet instance
    def each_order
      @edges.values.each { |order| yield(order) }
      self
    end

    # Public: Convenience method to subset edges, iterates over each order
    #
    # Yields the array being built, and the hash of edges at each order
    #
    # Returns an Array, the contents of the Array depend on the block
    def reduce_edges
      edges.values.inject([]) do |total, edges_at_order_n|
        yield(total, edges_at_order_n)
      end.flatten.uniq.sort
    end
  end
end
