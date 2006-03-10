#!/usr/bin/ruby

require 'test/unit'
require 'election_test_helper'

class TestPositionalVote < Test::Unit::TestCase
  include ElectionTestHelper

  def test_borda
    vote_array = Array.new
    3.times {vote_array << "ABC".split("")}
    3.times {vote_array << "CBA".split("")}
    2.times {vote_array << "BAC".split("")}

    test_winner( "B", BordaVote.new(vote_array).result )
  end
end

