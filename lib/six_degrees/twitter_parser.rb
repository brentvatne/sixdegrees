module SixDegrees
  # Parses a string containing tweets and builds a UserCollection
  # Note: Implemented as a Singleton because it has no state
  TwitterParser = Object.new

  class << TwitterParser

    # Public: Parse a string of text containing multiple tweets to
    # extract usernames, both of the user who tweeted and users
    # mentioned within tweets.
    #
    # tweets - The string to be parsed. If using a file, you must read it
    # first into a string and then pass that string in.
    #
    # Returns a new UserCollection object containing both users who have
    # tweeted and users have been mentioned, but not tweeted.
    def parse(tweets)
      users = UserCollection.new

      each_tweet(tweets) do |t|
        name     = parse_username(t)
        mentions = parse_mentions(t)

        users.add_mentions(name, mentions)
      end

      users
    end

    # Internal: Abstracts iteration over individual tweets
    #
    # tweets - A string containing multiple tweets separated by
    # newlines
    #
    # No meaningful return value
    def each_tweet(tweets)
      tweets.split("\n").each do |tweet|
        yield(tweet)
      end
    end

    # Internal: Finds the name of the user who made a given tweet
    #
    # tweet - A string containing a single tweet
    #
    # Returns a string with the name of the user, eg: "notbrent" or
    # "not_brent"
    def parse_username(tweet)
      tweet.match(/^[\w_]+/).to_a.first
    end

    # Internal: Finds the names of every mentioned user within a given
    # tweet
    #
    # tweet - A string containing a single tweet
    #
    # Returns an array with the names of each user
    def parse_mentions(tweet)
      tweet.scan(/@\w+/).to_a.map do |m|
        m.gsub!("@","")
      end
    end
  end
end
