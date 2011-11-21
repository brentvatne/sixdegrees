describe SixDegrees::SocialGraph do
  let(:tweets) {
		'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta @christie' + "\n" +
	  'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
	  'christie: @bob so I see it is Emerson tonight' + "\n" }

  let(:users) { SixDegrees::TwitterParser.parse(tweets) }
  subject { SixDegrees::SocialGraph.new(users) }

  describe "first order connections" do
    it "correctly identifies first order connections" do
      subject.first_order_connection?("alberta", "bob").should be_true

      subject.first_order_connection?("bob", "alberta").should be_true
      subject.first_order_connection?("bob", "christie").should be_true
    end
  end

  describe SixDegrees::NodeSet do
    let(:users) { SixDegrees::UserCollection.new }
    subject {SixDegrees::NodeSet.new(users.names) }

    before do
      users.find_or_create("vatne")
      users.find_or_create("john")
      users.find_or_create("brent")
    end

    describe "initialize" do
      it "should accept a list of users and initialize a node for each" do
        subject.length.should == users.length
      end

      it "should sort the nodes alphabetically" do
        subject.first.name.should == "brent"
      end

    end
  end

  describe SixDegrees::Node do
    describe "mutual_mentions" do
      it "should identify bi-directional (mutual) mentions" do
        bob = users.find("bob")
        alberta = users.find("alberta")
        christie = users.find("christie")

        alberta.mutual_mentions.should include bob
        alberta.mutual_mentions.should_not include christie
        bob.mutual_mentions.should include alberta
      end
    end
  end

	describe SixDegrees::SocialGraph::EdgeSet do
	end

end
