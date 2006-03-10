#!/usr/bin/ruby

require 'test/unit'
require 'election_test_helper'

class TestRangeVote < Test::Unit::TestCase
  include ElectionTestHelper

  def test_range
    vote_array = []
    42.times {vote_array << {'A' => 10, 'B' => 5, 'C' => 2, 'D' => 1}}
    26.times {vote_array << {'A' => 1, 'B' => 10, 'C' => 5, 'D' => 2}}
    15.times {vote_array << {'A' => 1, 'B' => 2, 'C' => 10, 'D' => 5}}
    17.times {vote_array << {'A' => 1, 'B' => 2, 'C' => 5, 'D' => 10}}

    test_winner('B', RangeVote.new(vote_array).result )
  end

  def test_tie
    vote_array = []
    10.times {vote_array << {'A' => 5, 'B' => 2}}
    10.times {vote_array << {'A' => 2, 'B' => 5}}

    test_winner(['A','B'], RangeVote.new(vote_array).result )
  end

  def test_no_win
    vote_array = []

    test_winner(nil, RangeVote.new(vote_array).result )
  end
end
