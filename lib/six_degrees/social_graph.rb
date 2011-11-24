module SixDegrees
	# Builds a social graph from a set of nodes and their mentions, and provides
  # methods to interact with the graph.
	class SocialGraph
    # Useful methods to make the class more readable
    include GraphUtilityMethods

    # A NodeSet instance
    attr_reader :nodes
    # An EdgeSet instance
    attr_reader :edges

    # Initializes the SocialGraph
    #
    # users - A UserCollection instance
    # depth - An integer specifying how many orders deep the connections
    # should go
    #
    # Returns a new SocialGraph instance
		def initialize(users, depth=6)
      @nodes = NodeSet.new(users.names)
      @edges = EdgeSet.new
      build_first_order(users)
      build_up_to_nth_order(depth)
			self
		end

    # Builds the first order of connections from a UserCollection
    # No useful return value
		def build_first_order(users)
      users.each do |user|
        connect :from  => user.name,
                :to => user.mutual_mentions.map(&:name),
                :order => 1
      end
		end	

    # Builds connections from order 2 to depth.
    # First order connections must be built prior to calling this method in order
    # for it to work.
    # No useful return value
    def build_up_to_nth_order(depth)
      (2..depth).each do |order|
        build_nth_order(order)
      end
    end

    # Builds the connections for a single specific order
    # (order-1) must already be built in order for this to work correctly.
    #
    # order - An integer representing the order to build
    #
    # No useful return value
    def build_nth_order(order)
      each_node_with_connections(order-1) do |node|
        connect :from => node, :to => discover_connections(node, order), :order => order
      end
    end

    # Traverses nodes connected to the subject node and finds new connections
    # (order-1) must already be built in order for this to work correctly.
    #
    # node  - The String name of the node whose connections will be searched for
    # order - The Integer order that the connections will be discovered for
    #
    # Returns an Array of Strings representing Nodes
    def discover_connections(node, order)
      connections = []
      each_node_connected_to node, :at => order-1 do |connected_node|
        first_order_connections(connected_node).each do |potential|
          connections << potential if not connected?(node, potential)
        end
      end
      connections
    end

    # Operates on the edgeset to create an edge between two nodes, or one node and
    # a collecion of nodes
    #
    # params: :source - The String name of the source node
    #         :to     - The String name of the target node, or alternatively, an
    #                   Array of names
    #         :order  - The Integer order at which this connection will be created
    #
    # No useful return value
		def connect(params)
      order = params[:order]; from = params[:from]; to = params[:to]

			if to.kind_of?(Enumerable)
				to.each do |singularized_to|
          connect :from => from, :to => singularized_to, :order => order
        end
			else
				edges.add(from, to, order)
			end
		end
  end
end
