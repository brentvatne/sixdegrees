describe SixDegrees::TwitterParser do
  let(:tweet) { 'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" }
  let(:multiple_tweets) { tweet + 'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta' + "\n" }

  describe "self#parse_name" do
    it "should parse the user name in a single tweet" do
      SixDegrees::TwitterParser.parse_username(tweet).should == "alberta"
    end
  end

  describe "self#parse_mentions" do
    it "should parse the mentions in a single tweet" do
      SixDegrees::TwitterParser.parse_mentions(tweet).should == ["bob", "christie"]
    end
  end

  describe "self#parse" do
    let(:parsed_users)    { SixDegrees::TwitterParser.parse(tweet) }
    let(:return_value)    { parsed_users }

    it "correctly parses the name of the user in a tweet" do
			parsed_users.should have_key("alberta")
    end

    it "correctly parses the users mentioned in a tweet" do
      parsed_users["alberta"].mentions.first.name.should == "bob"
    end

    it "parses more than one user" do
      users = SixDegrees::TwitterParser.parse(multiple_tweets)
      users.length.should == 3
    end
  end
end
