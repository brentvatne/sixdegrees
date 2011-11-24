module SixDegrees
  # Manages storage and retrieval of nodes
  #
  # Note: No Node class is being used as it would be a simply wrapper
  # around a String since no other behaviour is needed of Nodes at
  # this time. This class itself is not very useful either, and although I
  # considered removing it through refractoring, I left it in because it
  # makes sense within the problem domain to have a set of nodes as well as edges.
  # Also, if requirements change in the future and some functionality will
  # be requried of nodes, it will be easier to jump in and make the changes.
  class NodeSet
    include Enumerable

    # Public: Initializes the NodeSet
    #
    # names - An Array containing a list of Strings representing node names
    def initialize(names)
      @nodes = []
      names.each { |name| add_node(name) }
    end

    # Public: Adds a node to the NodeSet and sorts it
    #
    # Returns the NodeSet instance
    def add_node(name)
      @nodes << name unless @nodes.include?(name)
      @nodes.sort!
      self
    end

    # Public: Iterates over each node
    def each
      @nodes.each do |node|
        yield(node)
      end
    end

    # Public: Gets the last node
    #
    # Returns the last node in the collection
    def last
      @nodes.last
    end
  end
end
