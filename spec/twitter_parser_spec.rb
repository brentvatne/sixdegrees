describe SixDegrees::TwitterParser do
  let(:tweet) { 'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" }
  let(:tweets) {
		'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta @christie' + "\n" +
	  'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
	  'christie: @bob so I see it is Emerson tonight' + "\n" }

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
    let(:parsed_users)    { SixDegrees::TwitterParser.parse(tweets) }
    let(:return_value)    { parsed_users }

    it "correctly parses the name of the user in a tweet" do
			parsed_users.find("alberta").should be_true
    end

    it "correctly parses the users mentioned in a tweet" do
      alberta = parsed_users.find("alberta")
      bob = parsed_users.find("bob")
      christie = parsed_users.find("christie")

      alberta.mentioned?(bob).should be_true
      bob.mentioned?(alberta).should be_true
      bob.mentioned?(christie).should be_true
      christie.mentioned?(bob).should be_true
    end

    it "parses more than one user" do
      users = SixDegrees::TwitterParser.parse(tweets)
      pending
      # users.length.should == 3
    end
  end
end
