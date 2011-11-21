module SixDegrees
	# self.build_graph(..)
	# self.build_graph_from_twitter_file(..)
	
	# Builds a social graph from a set of users and their mentions, and
	# provides methods to interact with the graph.
	class SocialGraph
    attr_reader :nodes, :edges

		def initialize(people, depth=6)
      @nodes = NodeSet.new(people.names)
      @edges = EdgeSet.new
      build_first_order(people)
			# build_nth_order(depth)
			self
		end

    def first_order_connection?(node_name, other_node_name)
      edges.connected?(node_name, other_node_name, 1)
    end

    # Returns true if the from node is already connected to the to node
    # Will need to do something like flatten the hash and combine all levels of froms
    def connected?(from_node, to_node)

    end

		def build_first_order(people)
      people.each do |person|
        connect :from  => person, :to => person.mutual_mentions, :order => 1
      end
		end	

		def connect(params)
			from = params[:from]; to = params[:to]; order = params[:order]

			if to.kind_of?(Enumerable)
				to.each { |singularized_to| connect :from => from, :to => singularized_to, :order => order }
			else
				edges.add(from, to, order)
			end
		end

    class EdgeSet
      def initialize
        @edges = {}
      end

      def add(from, to, group)
        @edges[group] ||= {}
        @edges[group][from.name] ||= []

        @edges[group][from.name] << to.name
      end

      def connected?(from_name, to_name, group)
        !!(@edges.fetch(group).fetch(from_name).include?(to_name))
      end
    end
  end
end


# def order(n)
#   #figure out how to interact with the edges
#   #might make most sense to do something like
#   #[0] => {:brent => [person, person, person], :ana => [person, person]}
#   #[1] => {...}
#   #etc..
#   #and then order(1) would refer to [0] in the array (0 index)
# end

