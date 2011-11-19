# Provides StringScanner to perform parsing
require 'strscan'

# Packages the parse method and User class
# The only public method that can be called on Tweets
# is parse, which is a class method

class Tweets

  # Public: Parse a text buffer of tweets into users and mentions
  #
  # file - The buffer to be parsed, can be a File object or StringIO
  #
  # Examples:
  #
  #   tweets_file = File.open("tweets.txt")
  #   users = Tweets.parse(tweets_file)
  #   # => a collection of User objects
  #
  # Returns a collection of User objects
  class << self
    def parse(tweets)
      users = Hash.new { |hash, name| hash[name] = User.new(name) }

      each_tweet(tweets) do |t|
        name     = parse_username(t)
        mentions = parse_mentions(t)

        users[name].add_mentions(mentions)
      end

      users.values
    end

    def each_tweet(tweets)
      tweets.split(/\\n/).each do |tweet|
        yield(tweet)
      end
    end

    def parse_username(tweet)
      tweet.match(/^\w+/).to_a.first
    end

    def parse_mentions(tweet)
      tweet.scan(/@\w+/).to_a.map do |m|
        m.gsub!("@","")
      end
    end
  end


  class User
    attr_accessor :name, :mentions

    def initialize(name="alberta")
      self.name = name
      self.mentions = []
    end

    # Private: Merges a collection of names to existing mentions list
    # using set union to guarantee uniqueness of items
    def add_mentions(names)
      @mentions = @mentions | names
    end

    def mentioned?(name)
      @mentions.include?(name)
    end
  end

end
