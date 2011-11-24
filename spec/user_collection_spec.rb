describe SixDegrees::UserCollection do
  let(:tweets) {
		'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta @christie' + "\n" +
	  'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
	  'christie: @bob so I see it is Emerson tonight' + "\n" }
  subject { SixDegrees::TwitterParser.parse(tweets) }
  let(:bob) { subject.find("bob") }
  let(:alberta) { subject.find("alberta") }
  let(:christie) { subject.find("christie") }

  describe "add_mention" do
    describe "validations" do
      it "should not add the user's own name to their mentions" do
        original_length = bob.mentions.length
        bob.add_mention(bob)
        bob.mentions.length.should == original_length
      end

      it "should not add a user's name if they are already mentioned" do
        original_length = alberta.mentions.length
        alberta.mentioned?(bob).should == true
        alberta.add_mention(bob)
        alberta.mentions.length.should == original_length
      end
    end
  end
end

describe SixDegrees::User do
  let(:alberta) { SixDegrees::User.new("alberta") }
  let(:bob)     { SixDegrees::User.new("bob") }
  let(:brent)   { SixDegrees::User.new("brent") }

  before do
    alberta.add_mention(bob)
    bob.add_mentions([alberta, brent])
    brent.add_mention(bob)
  end

  describe "add_mention" do
    pending
  end

  describe "add_mentions" do
    pending
  end

  describe "mentioned?" do
    it "returns true when the user has been mentioned by the user" do
      alberta.mentioned?(bob).should be_true
    end
    it "returns false when the user has not been mentioned by the subject user" do
      brent.mentioned?(alberta).should be_false
    end
  end

  describe "mutual_mentions" do
    it "should accurately detect mutual mentions" do
      alberta.mutual_mentions.should include bob
      bob.mutual_mentions.should include(alberta,brent)
    end
  end
end
