describe SixDegrees::NodeSet do
  let(:users) { SixDegrees::UserCollection.new }
  subject     { SixDegrees::NodeSet.new(users.names) }

  before do
    users.find_or_create("vatne")
    users.find_or_create("john")
    users.find_or_create("brent")
  end

  describe "initialize" do
    it "should accept a list of users and initialize a node for each" do
      # subject.nodes.length.should == users.length
      pending
    end

    it "should sort the nodes alphabetically" do
      subject.first.should == "brent"
    end
  end
end
