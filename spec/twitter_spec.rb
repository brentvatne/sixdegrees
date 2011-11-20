describe SixDegrees::Twitter do
  let(:tweet) { 'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" }
  let(:multiple_tweets) { tweet + 'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta' + "\n" }

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

    it "correctly parses the name of the user in a tweet" do
			parsed_users.should have_key("alberta")
    end

    it "correctly parses the users mentioned in a tweet" do
      parsed_users["alberta"].mentions.first.name.should == "bob"
    end

    it "parses more than one user" do
      users = SixDegrees::Twitter.parse(multiple_tweets)
      users.length.should == 3
    end
  end

  context "SixDegrees::Twitter::User" do
    subject { SixDegrees::Twitter::User.new("alberta") }
    let(:bob) { SixDegrees::Twitter::User.new("bob") }
    let(:brent) { SixDegrees::Twitter::User.new("brent") }

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
end
