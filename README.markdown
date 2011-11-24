# RMU Entrance Exam Jan, 2011 - PuzzleNode: Six Degrees of Separation
### Brent Vatne

## Notes for the reviewers
I could have solved this problem with less code, but in the
interest of clarity I have tried to abstract away a lot of the details
into domain objects, such as EdgeSet.

I recently learned about TomDoc and it seems to me to be a clear and
effective way to document code for the benefit of your future self or
other programmers. Any feedback on what worked and did not work with my
commenting would be appreciated! Apologies in advance for being so verbose.

## What it does
### Problem Description
http://puzzlenode.com/puzzles/23

SocialGraph analyzes a set of tweets to determine which users are
connected through their mentions and at what order the connection exists.

A connection is determined using the following rules:

### First order connection

-   A is mentioned by B, B is mentioned by A
-   => A is first order with B, B is first order with A
    *note: if A mentions B and B does not mention A, there is no direct relationship

### nth order connection

-   A is n-1th order with B
-   B is first order with C
-   A has no connection higher than n-1th order with C
-   => A has a nth order connection with C

By default, SocialGraph determines up to the 6th order connection, but
you can pass in the desired depth as an Integer in the last parameter to a new
SocialGraph instance

## Use it

````ruby
require 'six_degrees'

tweets        = File.open("tweets.txt").read
twitter_users = SixDegrees::TwitterParser.parse(tweets)
social_graph  = SixDegrees::SocialGraph.new(twitter_users)
````

Or you can use the twitter_network.rb file from the command line:

`ruby bin/twitter_graph full_path_to_file`

## Run the tests
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with Ruby 1.9.3p0*

## Read the code
Extensive documentation has been provided inline, roughly according to
the TomDoc specification - http://tomdoc.org/

It's not really necessary to read over the TwitterParser or
UserCollection class unless you plan on implementing your own Parser. A
good starting point would be the SocialGraph class, to understand how it
uses the other classes to solve the problem. The included module,
GraphUtilityMethods might be a good second stop, to see what's going on
behind the scenes of the fairly high level methods in SocialGraph. From
there, you will want to look at EdgeSet, which does a lot of the heavy
lifting.

## Extend it
Write your own parser that populates a UserCollection instance with
users and their mentions, then pass that in to a new SocialGraph.
