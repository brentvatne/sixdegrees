libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'six_degrees/twitter_parser'
require 'six_degrees/user_collection'
require 'six_degrees/node_set'
require 'six_degrees/edge_set'
require 'six_degrees/graph_utility_methods'
require 'six_degrees/social_graph'
