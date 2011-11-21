module SixDegrees
	# self.build_graph(..)
	# self.build_graph_from_twitter_file(..)
	
	# Builds a social graph from a set of users and their mentions, and
	# provides methods to interact with the graph.
	class SocialGraph
    attr_reader :nodes, :edges

		def initialize(people, depth=6)
			@nodes = NodeSet.new(people)
			@edges = EdgeSet.new
			build_first_order(people)
			# build_nth_order(depth)
			self
		end

    def first_order_connection?(node)

    end

    def order(n)
      #figure out how to interact with the edges
      #might make most sense to do something like
      #[0] => {:brent => [person, person, person], :ana => [person, person]}
      #[1] => {...}
      #etc..
      #and then order(1) would refer to [0] in the array (0 index)
    end

		def build_first_order(people)
      people.each do |current_person|
        current_person.mentions.each do |mentioned_person|
          if mentioned_person.mentioned?(current_person)
            connect :from => nodes.find(current_person.name),
                    :to => nodes.find(mentioned_person.name),
                    :order => 1
          end
        end
      end
		end	

		def connect(params)
			from = params[:from]; to = params[:to]; order = params[:order]

			if to.respond_to(:[])
				to.each { |single_to| connect :from => from, :to => single_to, :order => order }
			else
				edges.add(source, target, order)
			end
		end

    class NodeSet
      include Enumerable

      def initialize(named)
        @set = []
        named.keys.each { |name| add_node(name) }
      end

      def add_node(name)
        @set << Node.new(name)
        @set.sort!
      end

      def each(&block)
        @set.each do |node|
          yield(node)
        end
      end

      def length
        @set.length
      end

      class Node
        attr_accessor :name

        def initialize(name)
          @name = name
        end

        def <=>(other)
          name.downcase <=> other.name.downcase
        end
      end
    end

    class EdgeSet

    end
	end
end

