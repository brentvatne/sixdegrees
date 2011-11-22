module SixDegrees
  # The job of this class is to manage logic related to connections between nodes
  class EdgeSet
    # Initializes from a collection of edges if they are passed in,
    # otherwise, initializes an empty collection
    def initialize(edge_set = false)
      sources = Hash.new { |hash, source_name| hash[source_name] = [] }
      @edges  = Hash.new { |hash, order_name| hash[order_name] = sources }
    end

    def add(source, target, order)
      @edges[order][source] << target
    end

    # Returns all nodes that are connected at order n
    def at_order(order) #or def at_order(n)
      @edges[order].keys
    end

    # Returns all edges that start at the given source name
    def starting_at(source)

    end

    # Returns all edges that end at the given target name
    def ending_at(target)

    end

    # Returns all edges without concern for the order
    def ignore_order

    end

    # If no order is passed, can iterate through all
    def connected?(source, target, order = :all)
      if order == :all
        #each order, check if include - use reduce?
      else
        !!(@edges.fetch(order).fetch(source).include?(target))
      end
    end
  end
end
