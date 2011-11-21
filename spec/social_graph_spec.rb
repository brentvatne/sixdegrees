describe SixDegrees::SocialGraph do
  #switch this to %Q and copy and paste the other file in!
  let(:tweets) {
		'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta' + "\n" +
	  'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
	  'christie: @bob so I see it is Emerson tonight' + "\n" }

  let(:users) { SixDegrees::Twitter.parse(tweets) }
  subject { SixDegrees::SocialGraph.new(users) }

  describe "first order connections" do
    it "correctly identifies first order connections" do
      # connections = subject.first_order_connections

      # connections["alberta"].should == ["bob"]
      # connections["bob"].should == ["alberta"]
      # connections["christie"].should == []
    end
  end

  describe SixDegrees::SocialGraph::NodeSet do
    let(:people) { {"vatne" => stub, "brent" => stub, "john" => stub} }
    subject {SixDegrees::SocialGraph::NodeSet.new(people) }

    describe "initialize" do
      it "should accept a list of people and initialize a node for each" do
        subject.length.should == people.keys.length
      end

      it "should sort the nodes alphabetically" do
        subject.first.name.should == "brent"
      end
    end
  end

	describe SixDegrees::SocialGraph::EdgeSet do

	end

end
