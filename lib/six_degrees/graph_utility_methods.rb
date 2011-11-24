module SixDegrees
  # A collection of methods that abstract away the details of dealing with EdgeSet and
  # NodeSet interfaces to make them more accesible. These methods make up the public
  # API of SocialGraph
  module GraphUtilityMethods

    # Public: Print users and their connections to output_buffer, default $stdout
    def print
      nodes.each do |node|
        @output_buffer.puts node
        edges.each_order do |order|
          @output_buffer.puts order[node].join(", ") if (order[node].length > 0)
        end
        @output_buffer.puts unless node == nodes.last
      end
    end

    # Public: Selects are first order connections for a given node
    #
    # node - A String representing a node
    #
    # Returns an array of Strings representing nodes
    def first_order_connections(node)
      edges.at_order(1).nodes_connected_to(node)
    end

    # Public: Determines if a first order connection exists from node "from" to node "to"
    #
    # Returns an array of Strings representing nodes
    def first_order_connection?(from, to)
      edges.connected?(from, to, 1)
    end

    # Public: Determines whether an edge exists a given node to the other given node
    #
    # Returns true if connected, false if not
    def connected?(from, to, order=:all)
      edges.connected?(from, to, order)
    end

    # Public: Iterates over each node that is the start point of a connection at a given order
    def each_node_with_connections(order)
      edges.at_order(order).sources.each do |node|
        yield(node)
      end
    end

    # Public: Iterates over each node that is the end point of a connection of the given node,
    # at any order
    def each_node_connected_to(node, params)
      order = params[:at]
      edges.at_order(order).nodes_connected_to(node).each do |connected_to|
        yield(connected_to)
      end
    end
  end
end
