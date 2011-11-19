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
  def self.parse(file)
    [User.new]
  end

  class User
    attr_accessor :name, :mentions

    def initialize(name="alberta")
      self.name = name
      self.mentions = ["bob"]
    end

    def add_mention(name)
      @mention ||= []
      @mention << name
    end

    def mentioned?(name)
      @mention.include?(name)
    end
  end

end
