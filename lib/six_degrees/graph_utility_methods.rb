module SixDegrees
  module GraphUtilityMethods
    # Takes a node, pulls out all connections, and converts them into
    # a single dimension array of nodes
    def first_order_connections(node)
      edges.at_order(1).nodes_connected_to(node)
    end

    def first_order_connection?(from, to)
      edges.connected?(from, to, 1)
    end

    # Returns true if the from node is already connected to the to node
    # Will need to do something like flatten the hash and combine all levels of froms
    def connected?(from, to, order=:all)
      edges.connected?(from, to, order)
    end

    def each_node_with_connections(order)
      edges.at_order(order).sources.each do |node|
        yield(node)
      end
    end

    def each_node_connected_to(node, params)
      order = params[:at]
      edges.at_order(order).nodes_connected_to(node).each do |connected_to|
        yield(connected_to)
      end
    end
  end
end
