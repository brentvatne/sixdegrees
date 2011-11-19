describe Tweets do

  context "Tweets.parse" do
    let(:tweet_file) { StringIO.new('alberta: @bob "It is remarkable,
                       the character of the pleasure we derive from
                       the best books.\n') }
    let(:parsed_users) { Tweets.parse(tweet_file) }
    let(:return_value) { parsed_users }

    it "returns a collection" do
      return_value.should respond_to(:[])
    end

    it "populates the returned collection with Tweets::User objects" do
      return_value.each do |item|
        item.should be_kind_of Tweets::User
      end
    end

    it "correctly parses the name of the user in a tweet" do
      parsed_users.first.name.should == "alberta"
    end

    it "correctly parses the users mentioned in a tweet" do
      parsed_users.first.mentions.should include("bob")
    end
  end

  context "Tweets::User" do

    describe "mentioned?" do
      subject { Tweets::User.new("alberta") }

      before do
        subject.add_mention("bob")
        subject.add_mention("brent")
      end

      it "returns true if the subject has been mentioned the given name" do
        subject.mentioned?("bob").should be_true
      end

      it "returns false if the subject has been mentioned the given name" do
        subject.mentioned?("jane").should be_false
      end
    end

  end
end
