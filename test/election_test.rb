#!/usr/bin/ruby

require 'test/unit'
require 'election_test_helper'

class TestElectionVote < Test::Unit::TestCase
  include ElectionTestHelper

  def test_plurality
    vote_array = "ABCABCABCCCBBAAABABABCCCCCCCCCCCCCA".split("")

    test_winner( "C", PluralityVote.new(vote_array).result )
  end


  def test_approval
    vote_array = Array.new
    10.times {vote_array << "AB".split("")}
    10.times {vote_array << "CB".split("")}
    11.times {vote_array << "AC".split("")}
    5.times {vote_array << "A".split("")}

    test_winner( "A", ApprovalVote.new(vote_array).result )
  end
end

