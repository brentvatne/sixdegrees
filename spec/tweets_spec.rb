describe Tweets do

  context "Tweets.parse" do

    let(:tweet_file) {
      StringIO.new('alberta: @bob "It is remarkable, the character of the 
                    pleasure we derive from the best books.\n') }
    let(:parsed) { Tweets.parse(tweet_file) }
    let(:return_value) { parsed }

    it "returns a collection" do
      return_value.should respond_to(:[])
    end

    it "populates the returned collection with TwitterUser objects" do
      return_value.each do |item|
        item.should be_kind_of Tweets::User
      end
    end

    # it "correctly parses the name of the user in a tweet" do
    #   parsed_users.first.name.should == "alberta"
    # end

    # it "correctly parses the users mentioned in a tweet" do
    #   parsed_users.first.mentions.should == ["bob"]
    # end

  end

end
