#!/usr/bin/ruby -Ilib

require 'test/unit'
require 'rubyvote/election'

class TestElectionVote < Test::Unit::TestCase

  def test_plurality_empty
    vote_array = []
    assert_nil PluralityVote.new(vote_array).result.winners[0]
    assert_equal(false, PluralityVote.new(vote_array).result.winner?)
  end
  
  def test_plurality
    vote_array = "ABCABCABCCCBBAAABABABCCCCCCCCCCCCCA".split("")

    assert_equal( "C", PluralityVote.new(vote_array).result.winners[0] )
  end

  def test_plurality_nonstring
    vote_array = [1,2,3,1,1,1,2,3]
    assert_equal( 1, PluralityVote.new(vote_array).result.winners[0] )
  end

  def test_invalid_voteobj
    vote_array = [1,2,nil,1]
    assert_raise(InvalidVoteError) { PluralityVote.new(vote_array).result.winners[0] }
  end
  
  def test_approval_empty
    vote_array = []
    assert_nil ApprovalVote.new(vote_array).result.winners[0]
    assert_equal(false, ApprovalVote.new(vote_array).result.winner?)
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

