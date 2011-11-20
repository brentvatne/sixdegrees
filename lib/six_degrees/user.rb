module SixDegrees
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
