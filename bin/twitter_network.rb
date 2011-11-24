require File.join(File.expand_path(File.dirname(__FILE__)), '/../lib/six_degrees')

module SixDegrees
  def self.build_graph_from_twitter_file(file)
    tweets = File.open(file).read
    users  = TwitterParser.parse(tweets)
    graph  = SocialGraph.new(users)
    self.print_graph(graph)
    end

  def self.print_graph(graph)
    graph.nodes.each do |node|
      puts node
      graph.edges.each_order do |order|
        puts order[node].join(", ") if (order[node].length > 0)
      end
      puts
    end
  end
end

SixDegrees::build_graph_from_twitter_file("/Users/CHIPI3/coding/ruby/sixdegrees/docs/complex_input.txt")

