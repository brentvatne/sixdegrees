describe SixDegrees::EdgeSet do
  subject     { SixDegrees::EdgeSet.new }
  let(:brent) { "brent" }
  let(:ana)   { "ana" }
  let(:jorge) { "jorge" }
  let(:diana) { "diana" }

  before do
    subject.add brent, ana,   1
    subject.add ana,   brent, 1

    subject.add ana,   jorge, 1
    subject.add jorge, ana,   1

    subject.add jorge, diana, 1
    subject.add diana, jorge, 1

    subject.add brent, jorge, 2
    subject.add ana,   diana, 2
    subject.add diana, ana,   2
    subject.add brent, diana, 3
  end


  describe "at_order" do
    it "returns a new EdgeSet with only the edges at the given order" do
      subject.at_order(1).connected?(brent, ana).should be_true
      subject.at_order(2).connected?(brent, ana).should be_false

      subject.at_order(2).connected?(brent, jorge).should be_true

      subject.at_order(3).connected?(brent, diana).should be_true
      subject.at_order(3).connected?(jorge, diana).should be_false
    end

    it "returns an empty EdgeSet instance if the order is not found" do
      subject.at_order(100).should be_kind_of SixDegrees::EdgeSet
      subject.at_order(100).edges.length.should == 0
    end
  end

  describe "nodes_connected_to" do
    it "only returns nodes connected the passed in node" do
      subject.nodes_connected_to(brent).each do |supposedly_connected|
        subject.connected?(brent, supposedly_connected).should be_true
      end
    end

    it "get these nodes from every order" do
      subject.nodes_connected_to(brent).should include(ana)
      subject.nodes_connected_to(brent).should include(jorge)
      subject.nodes_connected_to(brent).should include(diana)
    end
  end

  describe "sources" do
    it "should be sorted" do
      subject.sources.should == subject.sources.sort
    end

    it "returns all sources" do
      subject.sources.should == [ana, brent, diana, jorge]
    end

    it "can be chained with at_order to return only sources from a certain order" do
      subject.at_order(2).sources.should == [ana, brent, diana]
    end
  end
end
