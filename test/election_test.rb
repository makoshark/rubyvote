#!/usr/bin/ruby -Ilib

require 'test/unit'
require 'rubyvote/election'

class TestElectionVote < Test::Unit::TestCase

  def test_plurality
    vote_array = "ABCABCABCCCBBAAABABABCCCCCCCCCCCCCA".split("")

    assert_equal( "C", PluralityVote.new(vote_array).result.winners[0] )
  end


  def test_approval
    vote_array = Array.new
    10.times {vote_array << "AB".split("")}
    10.times {vote_array << "CB".split("")}
    11.times {vote_array << "AC".split("")}
    5.times {vote_array << "A".split("")}

    assert_equal( "A", ApprovalVote.new(vote_array).result.winners[0] )
  end
end

