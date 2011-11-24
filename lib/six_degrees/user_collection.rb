module SixDegrees
  # Acts as the interface between a Parser and the SocialGraph
  #
  # To extend SixDegrees to support other types of data, simply write the
  # parser and feed it into an instance of the UserCollection class, which
  # you can then pass to SocialGraph.
  class UserCollection
    include Enumerable

    # Public: Initializes a UserCollection
    def initialize
      @users = Hash.new { |hash, name| hash[name] = User.new(name) }
    end

    # Public: Gets all users names
    #
    # Returns an array of Strings representing user names
    def names
      @users.values.map(&:name)
    end

    # Public: Iterates over each User
    #
    # Yields each User object in the collection
    #
    # No useful return value
    def each
      @users.values.each do |user|
        yield(user)
      end
    end

    # Public: Add a list of mentions to a User
    #
    # name     - A String representing the name of the user to add mentions to
    # mentions - An Array of Strings representing User names
    #
    # Returns the instance of UserCollection
    def add_mentions(name, mentions)
      find_or_create(name).add_mentions(names_to_references(mentions))
      self
    end

    # Inernal: Converts an array of name strings to User object references
    #
    # names - An Array of Strings representing User names
    #
    # Returns an Array of User objects corresponding to the names passed in
    def names_to_references(names)
      names.map { |name| find_or_create(name) }
    end

    # Public: Selects an existing User or creates and selects a User
    #
    # Returns a User object
    def find_or_create(name)
      @users[name]
    end

    # Public: Selects an existing User, throws an error if not found
    #
    # Returns a User object
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

    # Public: Initializes the User
    #
    # name - A String
    #
    # Returns an instance of User
    def initialize(name)
      @name = name
      @mentions = []
    end

    # Public: Accepts a collection of names and proxies them one by
    # one to the add_mention method
    #
    # Returns the User instance
    def add_mentions(users)
      users.each { |user| add_mention(user) }
      self
    end

    # Public: Performs validation before adding a name to the list
    #
    # Returns the User instance
    def add_mention(user)
      @mentions << user unless user.name == self.name or mentions.include?(user)
      self
    end

    # Public: Determines whether this user has mentioned the given user
    #
    # Returns true if yes, false if no
    def mentioned?(user)
      @mentions.include?(user)
    end

    # Public: Selects all users that are mentioned by this user that also
    # mention this user
    #
    # Returns an Array of User objects
    def mutual_mentions
      mentions.select do |mentioned_user|
        mentioned_user.mentioned?(self)
      end
    end
  end
end
