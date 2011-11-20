module SixDegrees
  # Packages methods for parsing a string containing multiple tweets.
  # Write your own module that implements parse and returns a collection
  # of objects which implement the User interface to extend.
  module Twitter

    # Public: Parse a string of text containing multiple tweets to
    # extract usernames, both of the user who tweeted and users
    # mentioned within tweets.
    #
    # file - The string to be parsed. If using a file, you must read it
    # first into a string and then pass that string in.
    #
    # Examples:
    #
    #   tweets = File.open("tweets.txt").read
    #   users = Twitter.parse(tweets)
    #   # => a hash of User objects
    #
    # Returns a hash of User objects, keyed by a String for name. The User
    # object includes users who have tweeted and those have not tweeted but
    # have been mentioned.
    class << self
      def parse(tweets)
        @users = Hash.new { |hash, name| hash[name] = User.new(name) }

        each_tweet(tweets) do |t|
          name     = parse_username(t)
          mentions = names_to_references(parse_mentions(t))

          @users[name].add_mentions(mentions)
        end

        @users
      end

      # This looks like it belongs in a UserCollection class!
      def names_to_references(names)
        names.map { |name| @users[name] }
      end

      # Private: Abstracts iteration over individual tweets
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

      # Private: Finds the name of the user who made a given tweet
      #
      # tweet - A string containing a single tweet
      #
      # Returns a string with the name of the user, eg: "notbrent"
      def parse_username(tweet)
        tweet.match(/^\w+/).to_a.first
      end

      # Private Finds the names of every mentioned user within a given
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
end
