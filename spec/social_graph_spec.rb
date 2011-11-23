describe SixDegrees::SocialGraph do
  subject { SixDegrees::SocialGraph.new(users) }
  let(:users) { SixDegrees::TwitterParser.parse(tweets) }

  describe "acceptance test" do
    let(:tweets) { File.open(Dir.pwd + "/docs/sample_input.txt").read }

    it "correctly identifies first order connections in the sample file" do
      subject.first_order_connection?("alberta", "bob").should be_true
      subject.first_order_connection?("alberta", "christie").should be_true

      subject.first_order_connection?("bob", "alberta").should be_true
      subject.first_order_connection?("bob", "christie").should be_true
      subject.first_order_connection?("bob", "duncan").should be_true

      subject.first_order_connection?("christie", "alberta").should be_true
      subject.first_order_connection?("christie", "bob").should be_true
      subject.first_order_connection?("christie", "emily").should be_true

      subject.first_order_connection?("duncan", "bob").should be_true
      subject.first_order_connection?("duncan", "emily").should be_true
      subject.first_order_connection?("duncan", "farid").should be_true
      subject.first_order_connection?("duncan", "alberta").should be_false

      subject.first_order_connection?("emily", "christie").should be_true
      subject.first_order_connection?("emily", "duncan").should be_true
      subject.first_order_connection?("emily", "bob").should be_false

      subject.first_order_connection?("farid", "duncan").should be_true
      subject.first_order_connection?("farid", "emily").should be_false
    end

		it "correctly identifies second order connections in the sample file" do
			subject.connected?("alberta", "duncan", 2).should be_true
			subject.connected?("alberta", "emily", 2).should be_true
			subject.connected?("alberta", "bob", 2).should be_false

			subject.connected?("bob", "emily", 2).should be_true
			subject.connected?("bob", "farid", 2).should be_true
			subject.connected?("bob", "alberta", 2).should be_false

			subject.connected?("christie", "duncan", 2).should be_true
			subject.connected?("christie", "alberta", 2).should be_false

			subject.connected?("duncan", "alberta", 2).should be_true
			subject.connected?("duncan", "christie", 2).should be_true
			subject.connected?("duncan", "emily", 2).should be_false

			subject.connected?("emily", "alberta", 2).should be_true
			subject.connected?("emily", "bob", 2).should be_true
			subject.connected?("emily", "farid", 2).should be_true
			subject.connected?("emily", "christie", 2).should be_false

			subject.connected?("farid", "bob", 2).should be_true
			subject.connected?("farid", "emily", 2).should be_true
			subject.connected?("farid", "duncan", 2).should be_false
		end

		it "correctly identifies third order connections in the sample file" do
			subject.connected?("alberta", "farid", 3).should be_true

			subject.connected?("christie", "farid", 3).should be_true

			subject.connected?("farid", "alberta", 3).should be_true
			subject.connected?("farid", "christie", 3).should be_true
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
