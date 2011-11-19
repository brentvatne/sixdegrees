describe Tweets do

  let(:tweet) { 'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie\n' }
  let(:multiple_tweets) { tweet + 'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta\n' }

  describe "Tweets.parse_name" do
    it "should parse the user name" do
      Tweets.parse_username(tweet).should == "alberta"
    end
  end

  describe "Tweets.parse_mentions" do
    it "should parse the mentions" do
      Tweets.parse_mentions(tweet).should == ["bob", "christie"]
    end
  end

  describe "Tweets.parse" do
    let(:parsed_users)    { Tweets.parse(tweet) }
    let(:return_value)    { parsed_users }

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

    it "parses more than one user" do
      users = Tweets.parse(multiple_tweets)
      first_user, second_user = users.first(2)

      first_user.name.should == "alberta"
      second_user.name.should == "bob"

      first_user.mentions.should include("bob")
      first_user.mentions.should include("christie")
      second_user.mentions.should include("alberta")
    end
  end

  context "Tweets::User" do
    describe "mentioned?" do
      subject { Tweets::User.new("alberta") }

      before do
        subject.add_mentions(["bob", "brent"])
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
