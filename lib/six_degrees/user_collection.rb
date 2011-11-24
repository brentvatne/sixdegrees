module SixDegrees
  class UserCollection
    include Enumerable

    def initialize
      @users = Hash.new { |hash, name| hash[name] = User.new(name) }
    end

    def names
      @users.values.map(&:name)
    end

    def each
      @users.values.each do |user|
        yield(user)
      end
    end

    def add_mentions(name, mentions)
      find_or_create(name).add_mentions(names_to_references(mentions))
    end

    def names_to_references(names)
      names.map { |name| @users[name] }
    end

    def find_or_create(name)
      @users[name]
    end

    def find(name)
      @users.fetch(name)
    end
  end

  # Encapsulates the concept of a User that has a name and mentions
  # other users. A convenience class to make interacting with this
  # data easier and in appropriate domain language.
  class User
    # A String
    attr_reader :name
    # An Array of User objects
    attr_reader :mentions

    def initialize(name)
      @name = name
      @mentions = []
    end

    # Accepts a collection of names and proxies them one by
    # one to the add_mention method
    #
    # Returns a reference to the mentions array
    def add_mentions(users)
      users.each { |user| add_mention(user) }
      mentions
    end

    # Performs validation before adding a name to the list
    #
    # Returns a reference to the mentions array
    def add_mention(user)
      @mentions << user unless user.name == self.name or mentions.include?(user)
      mentions
    end

    # Determines whether the user has mentioned another user
    #
    # Returns true if yes, false if no
    def mentioned?(user)
      @mentions.include?(user)
    end

    # Selects all users that are mentioned by this user that also mention this user
    #
    # Returns an Array of User objects
    def mutual_mentions
      mentions.select do |mentioned_user|
        mentioned_user.mentioned?(self)
      end
    end
  end
end
