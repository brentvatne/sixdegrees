module SixDegrees
	class SocialGraph
		def initialize(people, depth)
			@nodes = NodeSet.new(people)
			@edges = EdgeSet.new
			build_first_order(people)
			build_nth_order(depth)
			self
		end

    def print_all_connections_alphabetically
    end

		def build_first_order(people)
			nodes.each do |node|
				people[node.name].mentions.each do |mention|
					if mention.mentioned?(person)	
						#note: if a user has been mentioned but does not exist, find will not work
						connect :from => node, :to => nodes.find(mention.name), :order => 1
					end
				end	
			end
		end	

		def build_nth_order(n)
			#yields each node that has a connection at the given order - the outer loop of the pseudocode
			each_node_with_connections_at_order(n-1) do |node|
				#the inner loop - each connection of that node, see if already connected, if not, is first order
				connections = discover_connections :node => node, :order => n
				#add connection to edge, connections will be a set
				connect :from => node, :to => connections, :order => n
			end
		end


		#for a SINGLE node
		def discover_connections(params)
			node = params[:node]; order = params[:order]
			connections = []

			each_node_connected_to node, :at => order do |connected_node|
				#find their first level connections
				@edges.first_order(connected_node).each do |potential|
						connections << potential if not connected?(potential, node)	
				end
			end
			# => returns an array of node objects to connect to
		end


		def connect(params)
			from = params[:from]; to = params[:to]; order = params[:order]

			if to.respond_to(:[])
				to.each { |single_to| connect :from => from, :to => single_to, :order => order }
			else
				@edges.add(source, target, order)
			end
		end

		class NodeSet
			class Node
			end	
		end

		class EdgeSet

			class Edge
			end
		end
	end
end
