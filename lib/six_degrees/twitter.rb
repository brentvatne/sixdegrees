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
    # Returns a hash of User objects, keyed by a String for name
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

    # Encapsulates the concept of a User that has a name and mentions
    # other users. A convenience class to make interacting with this
    # data easier and in appropriate domain language.
    class User
      attr_reader :name, :mentions

      def initialize(name)
        @name = name
        @mentions = []
      end

      # Public: Determines whether the user has mentioned another user
      #
      # Returns true if yes, false if no
      def mentioned?(name)
        mentions.each do |mention|
          return true if mention.name == name
        end
        false
      end

      # Public: Performs validation before adding a name to the list
      #
      # Returns a reference to the mentions array
      def add_mention(user)
        @mentions << user unless user.name == self.name or mentions.include?(user)
        mentions
      end

      # Public: Accepts a collection of names and proxies them one by
      # one to the add_mention method
      #
      # Returns a reference to the mentions array
      def add_mentions(users)
        users.each { |user| add_mention(user) }
        mentions
      end
    end
  end
end
