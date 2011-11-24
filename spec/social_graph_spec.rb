describe SixDegrees::SocialGraph do
  subject { SixDegrees::SocialGraph.new(users) }
  let(:users) { SixDegrees::TwitterParser.parse(tweets) }

  describe "acceptance test" do
    let(:tweets) { File.open(Dir.pwd + "/docs/simple_input.txt").read }
    let(:solution) { File.open(Dir.pwd + "/docs/simple_output.txt").read }

    it "correctly solves the simple solution" do
      output_buffer = StringIO.new
      SixDegrees::SocialGraph.new(users, 6, output_buffer).print
      output_buffer.rewind
      output_buffer.read.should == solution
    end
  end

  describe "first order connections" do
    let(:tweets) {
      'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta @christie' + "\n" +
      'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
      'christie: @bob so I see it is Emerson tonight' + "\n" }

    it "correctly identifies first order connections" do
      subject.first_order_connection?("alberta", "bob").should be_true

      subject.first_order_connection?("bob", "alberta").should be_true
      subject.first_order_connection?("bob", "christie").should be_true
    end
  end

  describe "each_node_with_connections_at_order" do
    it "returns nodes connected at the given order" do

    end

    it "does not return nodes that are not connected at that order" do

    end
  end
end
