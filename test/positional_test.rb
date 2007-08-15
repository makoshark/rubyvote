#!/usr/bin/ruby -Ilib

require 'test/unit'
require 'rubyvote/election'
require 'rubyvote/positional'

class TestPositionalVote < Test::Unit::TestCase
  
  def test_borda_empty
    vote_array = Array.new
    assert_nil BordaVote.new(vote_array).result.winners[0]
    assert_equal(false, BordaVote.new(vote_array).result.winner?)
  end
  
  def test_borda
    vote_array = Array.new
    2.times {vote_array << "BAC".split("")}
    3.times {vote_array << "ABC".split("")}
    3.times {vote_array << "CBA".split("")}
    
    assert_equal( "B", BordaVote.new(vote_array).result.winners[0] )
  end
  
end

