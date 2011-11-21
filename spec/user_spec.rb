describe SixDegrees::User do
  subject { SixDegrees::User.new("alberta") }
  let(:bob) { SixDegrees::User.new("bob") }
  let(:brent) { SixDegrees::User.new("brent") }

  describe "mentioned?" do
    before do
      subject.add_mentions([bob, brent])
    end

    it "returns true if the subject has been mentioned the given name" do
      subject.mentioned?("bob").should be_true
    end

    it "returns false if the subject has been mentioned the given name" do
      subject.mentioned?("jane").should be_false
    end
  end

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
