# RMU Entrance Exam Jan, 2011 - PuzzleNode: Six Degrees of Separation
### Brent Vatne

## Notes for the reviewers
Hello! Thanks for taking the time to read this and evaluate my
application. I apologize for the verbosity, feel free to skim through.
Check out the "Read the Code" section below for my suggestions on how
you can go about understanding my solution.

## Use it

````ruby
require 'six_degrees'

tweets        = File.open("tweets.txt").read
twitter_users = SixDegrees::TwitterParser.parse(tweets)
social_graph  = SixDegrees::SocialGraph.new(twitter_users)
````

Or you can use `/bin/twitter_network` from the command line:

`ruby bin/twitter_graph full_path_to_file`

Run it with the examples:

`ruby bin/twitter_graph simple`
`ruby bin/twitter_graph complex`

## Run the tests
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with Ruby 1.9.3p0*

## Read the code
It's not really necessary to read over the TwitterParser or
UserCollection class unless you plan on implementing your own Parser. A
good starting point would be the SocialGraph class, to understand how it
uses the other classes to solve the problem. The included module,
GraphUtilityMethods might be a good second stop, to see what's going on
behind the scenes of the fairly high level methods in SocialGraph. From
there, you will want to look at EdgeSet, which does a lot of the heavy
lifting.

Extensive documentation has been provided inline, roughly according to
the TomDoc specification - http://tomdoc.org/
If the code looks incredibly long it might be because of the
documentation, or it might actually be long.

## Extend it
Write your own parser that populates a UserCollection instance with
users and their mentions, then pass that in to a new SocialGraph.

## What it does (down at the bottom because evaluaters already know!)
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
