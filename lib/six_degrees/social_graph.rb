module SixDegrees
  def self.build_graph_from_twitter_file(file)
    tweets = File.open(file).read
    users  = TwitterParser.parse(tweets)
    graph  = SocialGraph.new(users)
    self.print_graph(graph)
    end

  def self.print_graph(graph)
    graph.nodes.each do |node|
      puts node.name
      graph.edges.each_order do |order|
        puts order[node].join(", ") if (order[node].length > 0)
      end
      puts
    end
  end

  def self.print_graph_alphabetically(graph)
  end

	# self.build_graph(..)
	# self.build_graph_from_twitter_file(..)
	
	# Builds a social graph from a set of nodes and their mentions, and
	# provides methods to interact with the graph.
	class SocialGraph
    attr_reader :nodes
    attr_reader :edges

		def initialize(users, depth=6)
      @nodes = NodeSet.new(users.names)
      @edges = EdgeSet.new
      build_first_order(users)
      build_up_to_nth_order(depth)
			self
		end

		def build_first_order(users)
      users.each do |user|
        connect :from  => user, :to => user.mutual_mentions, :order => 1
      end
		end	

    def build_up_to_nth_order(depth)
      (2..depth).each do |order|
        build_nth_order(order)
      end
    end

    def build_nth_order(order)
      #yields each node that has a connection at the given order - the outer loop of the pseudocode
      each_node_with_connections(order-1) do |node|
        connect :from => node, :to => discover_connections(node, order), :order => order
      end
    end

    def discover_connections(node, order)
      connections = []
      each_node_connected_to node, :at => order-1 do |connected_node|
        first_order_connections(connected_node).each do |potential|
          connections << potential if not connected?(node, potential)
        end
      end
      connections
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

    # Returns true if the from node is already connected to the to node
    # Will need to do something like flatten the hash and combine all levels of froms
    def connected?(from, to, order=:all)
      from = nodes.find_by_name(from) if not from.kind_of?(User)
      to   = nodes.find_by_name(to) if not from.kind_of?(User)
      edges.connected?(from, to, order)
    end

    # Operates on the edgeset to create an edge between two nodes, or one node and a collecion of nodes
    #
    # params
    #   source - Name of the source node
    #   to     - Name of the target node, or alternatively, an array of names
    #   order  - The order at which this connection will be created
    #
    # No useful return value
		def connect(params)
      order = params[:order]; from = params[:from]; to = params[:to]
			from  = nodes.find_by_name(from.name) if from.kind_of?(User)
			to    = nodes.find_by_name(to.name) if to.kind_of?(User)

			if to.kind_of?(Enumerable)
				to.each do |singularized_to|
          connect :from => from, :to => singularized_to, :order => order
        end
			else
				edges.add(from, to, order)
			end
		end

    # Takes a node, pulls out all connections, and converts them into
    # a single dimension array of nodes
    def first_order_connections(node)
      edges.at_order(1).nodes_connected_to(node)
    end

    def first_order_connection?(from, to)
      edges.connected?(nodes.find_by_name(from), nodes.find_by_name(to), 1)
    end
  end
end
