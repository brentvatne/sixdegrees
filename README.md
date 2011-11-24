RMU Entrance Exam for January, 2012
====================================
PuzzleNode: Six Degrees of Separation
--------------------------------------
###http://puzzlenode.com/puzzles/23
-------------------------------------
Tested with Ruby 1.9.3p0

Sample Usage:
--------------

````ruby
require 'six_degrees'

tweets        = File.open("tweet_file.txt").read
twitter_users = SixDegrees::TwitterParser.parse(tweets)
social_graph  = SixDegrees::SocialGraph.new(twitter_users)
````

Or you can use the twitter_network.rb file from the command line:

    ruby bin/twitter_graph full_path_to_file

Parsing:
--------------
The tweets file is parsed it into a UserCollection. In order to extend SixDegrees to work with 
other types of raw data, simply write a new parser that creates a UserCollection instance.

Building a Graph:
------------------
The graph builder takes the users and their mentions and builds a social graph
out of it, and the graph can be accessed through the following api:

Connections:
------------
A connection is determined using the following rules:

All examples are from the point of view of A.

First order:
  - A is mentioned by B, B is mentioned by A
  => A is first order with B, B is first order with A
  *note: if A mentions B and B does not mention A, there is no direct relationship

Second order:
  - A is first order with B
  - B is first order with C
  - A is not first order with C
  => A is second order with C

Third order:
  - A is second order with B
  - B is first order with C
  - A has no higher level connection with C
  => A is third order with C

nth order:
  - A is n-1th order with B
  - B is first order with C
  - A has no connection higher than n-1th order with C
  => A has a nth order connection with C
