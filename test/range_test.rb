#!/usr/bin/ruby -Ilib

require 'test/unit'
require 'rubyvote/election'
require 'rubyvote/range'

class TestRangeVote < Test::Unit::TestCase

  def test_range_empty
    vote_array = []
    assert_nil RangeVote.new(vote_array).result.winners[0]
    assert_equal(false, RangeVote.new(vote_array).result.winner?)
  end
  
  def test_range
    vote_array = []
    42.times {vote_array << {'A' => 10, 'B' => 5, 'C' => 2, 'D' => 1}}
    26.times {vote_array << {'A' => 1, 'B' => 10, 'C' => 5, 'D' => 2}}
    15.times {vote_array << {'A' => 1, 'B' => 2, 'C' => 10, 'D' => 5}}
    17.times {vote_array << {'A' => 1, 'B' => 2, 'C' => 5, 'D' => 10}}

    assert_equal('B', RangeVote.new(vote_array).result.winners[0] )
  end

  def test_tie
    vote_array = []
    10.times {vote_array << {'A' => 5, 'B' => 2}}
    10.times {vote_array << {'A' => 2, 'B' => 5}}

    assert_equal(['A','B'], RangeVote.new(vote_array).result.winners )
  end

  def test_no_win
    vote_array = []

    assert_equal(nil, RangeVote.new(vote_array).result.winners[0] )
  end
end
