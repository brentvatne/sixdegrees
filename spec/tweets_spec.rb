describe SixDegrees::Twitter do
  let(:tweet) { 'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie\n' }
  let(:multiple_tweets) { tweet + 'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta\n' }

  describe "self#parse_name" do
    it "should parse the user name in a single tweet" do
      SixDegrees::Twitter.parse_username(tweet).should == "alberta"
    end
  end

  describe "self#parse_mentions" do
    it "should parse the mentions in a single tweet" do
      SixDegrees::Twitter.parse_mentions(tweet).should == ["bob", "christie"]
    end
  end

  describe "self#parse" do
    let(:parsed_users)    { SixDegrees::Twitter.parse(tweet) }
    let(:return_value)    { parsed_users }

    it "returns a collection" do
      return_value.should respond_to(:[])
    end

    it "correctly parses the name of the user in a tweet" do
      parsed_users.first.name.should == "alberta"
    end

    it "correctly parses the users mentioned in a tweet" do
      parsed_users.first.mentions.should include("bob")
    end

    it "parses more than one user" do
      users = SixDegrees::Twitter.parse(multiple_tweets)
      first_user, second_user = users.first(2)

      first_user.name.should == "alberta"
      second_user.name.should == "bob"

      first_user.mentions.should include("bob")
      first_user.mentions.should include("christie")
      second_user.mentions.should include("alberta")
    end
  end

  context "SixDegrees::Twitter::User" do
    describe "mentioned?" do
      subject { SixDegrees::Twitter::User.new("alberta") }

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

    describe "add_mention" do
      subject { SixDegrees::Twitter::User.new("brent") }

      describe "validations" do
        it "should not add the user's own name to their mentions" do
          subject.add_mention("brent")
          subject.mentions.should be_empty
        end

        it "should not add a user's name if they are already mentioned" do
          after_first_mention  = subject.add_mention("ana maria")
          after_second_mention = subject.add_mention("ana ma")
          after_first_mention.should == after_second_mention
        end
      end
    end
  end
end
