## RMU Entrance Exam Jan, 2011 - PuzzleNode: Six Degrees of Separation
### Problem Description:
http://puzzlenode.com/puzzles/23

### Run the tests:
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with Ruby 1.9.3p0*

### Use it:

````ruby
require 'six_degrees'

tweets        = File.open("tweets.txt").read
twitter_users = SixDegrees::TwitterParser.parse(tweets)
social_graph  = SixDegrees::SocialGraph.new(twitter_users)
````

Or you can use the twitter_network.rb file from the command line:

`ruby bin/twitter_graph full_path_to_file`

### Read the code:
Extensive documentation has been provided inline, roughly according to
the TomDoc specification - http://tomdoc.org/

### Extend it:
Write your own parser that populates a UserCollection instance with
users and their mentions, then pass that in to a new SocialGraph.

### What it does:
SocialGraph analyzes a set of tweets to determine which users are
connected through their mentions and at what order the connection exists.

A connection is determined using the following rules:

#### First order connection:

-   A is mentioned by B, B is mentioned by A
-   => A is first order with B, B is first order with A
    *note: if A mentions B and B does not mention A, there is no direct relationship

#### nth order connection:

-   A is n-1th order with B
-   B is first order with C
-   A has no connection higher than n-1th order with C
-   => A has a nth order connection with C

By default, SocialGraph determines up to the 6th order connection, but
you can pass in the desired depth as an Integer in the last parameter to a new
SocialGraph instance
