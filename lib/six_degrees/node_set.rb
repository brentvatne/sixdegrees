module SixDegrees
  class SocialGraph
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
  end
end
