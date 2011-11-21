describe SixDegrees::UserCollection do
  subject { SixDegrees::User.new("alberta") }
  let(:bob) { SixDegrees::User.new("bob") }
  let(:brent) { SixDegrees::User.new("brent") }

  describe "add_mention" do
    describe "validations" do
      it "should not add the user's own name to their mentions" do
        brent.add_mention(brent)
        subject.mentions.should be_empty
      end

      it "should not add a user's name if they are already mentioned" do
        after_first_mention  = Array.new(subject.add_mention(brent))
        after_second_mention  = Array.new(subject.add_mention(brent))
        after_first_mention.should == after_second_mention
      end
    end
  end
end

describe SixDegrees::User do
  subject { SixDegrees::User.new("alberta") }
  let(:bob) { SixDegrees::User.new("bob") }
  let(:brent) { SixDegrees::User.new("brent") }

  before do
    subject.add_mentions([bob])
    bob.add_mentions([subject, brent])
    brent.add_mentions([bob])
  end

  describe "mentioned?" do
    it "returns true when the user has been mentioned by the subject user" do
      subject.mentioned?(bob).should be_true
    end
    it "returns false when the user has not been mentioned by the subject user" do
      brent.mentioned?(subject).should be_false
    end
  end

  describe "mutual_mentions" do
    it "should accurately detect mutual mentions" do
      subject.mutual_mentions.should include(bob)
      bob.mutual_mentions.should include(subject, brent)
    end
  end
end
