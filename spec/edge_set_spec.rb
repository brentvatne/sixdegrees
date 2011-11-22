describe SixDegrees::EdgeSet do
  subject { SixDegrees::EdgeSet.new }
  let(:brent)    { "brent" }
  let(:ana)      { "ana" }
  let(:mauricio) { "mauricio" }
  let(:diego)    { "diego" }
  let(:jorge)    { "jorge" }
  let(:diana)    { "diana" }

  # describe "initialize" do
  #   it "returns a new edgeset built from edges if passed a collection of edges" do
  #     pending
  #   end
  # end

  before do
    subject.add brent, ana, 1
    subject.add ana, brent, 1

    subject.add ana, jorge, 1
    subject.add jorge, ana, 1

    subject.add jorge, diana, 1
    subject.add diana, jorge, 1

    subject.add brent, jorge, 2
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
  end

  describe "endpoints" do
    
  end

  describe "starting_at" do
    # pending
  end

  # describe "ending_at" do
  #   pending
  # end

  # describe "connected?" do
  #   pending
  # end

  # describe "ignore_order" do
  #   pending
  # end
end
