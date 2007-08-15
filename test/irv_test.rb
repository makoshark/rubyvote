#!/usr/bin/ruby -Ilib

require 'test/unit'
require 'rubyvote/election'
require 'rubyvote/irv'

class TestRunoffVote < Test::Unit::TestCase

  def test_irv_empty
    vote_array = Array.new
    assert_nil InstantRunoffVote.new(vote_array).result.winners[0]
    assert_equal(false, InstantRunoffVote.new(vote_array).result.winner?)
  end
  
  def test_irv
    vote_array = Array.new
    142.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    17.times {vote_array << "DCBA".split("")}

    assert_equal( "A", InstantRunoffVote.new(vote_array).result.winners[0] )
  end

  def test_irv2
    vote_array = Array.new
    42.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    17.times {vote_array << "DCBA".split("")}

    assert_equal( "D", InstantRunoffVote.new(vote_array).result.winners[0] )
  end

  def test_irv3
    vote_array = Array.new
    42.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "ACBD".split("")}
    15.times {vote_array << "BACD".split("")}
    32.times {vote_array << "BCAD".split("")}
    14.times {vote_array << "CABD".split("")}
    49.times {vote_array << "CBAD".split("")}
    17.times {vote_array << "ABDC".split("")}
    23.times {vote_array << "BADC".split("")}
    37.times {vote_array << "BCDA".split("")}
    11.times {vote_array << "CADB".split("")}
    16.times {vote_array << "CBDA".split("")}
    54.times {vote_array << "ADBC".split("")}
    36.times {vote_array << "BDCA".split("")}
    42.times {vote_array << "CDAB".split("")}
    13.times {vote_array << "CDBA".split("")}
    51.times {vote_array << "DABC".split("")}
    33.times {vote_array << "DBCA".split("")}
    39.times {vote_array << "DCAB".split("")}
    12.times {vote_array << "DCBA".split("")}

    assert_equal( "C", InstantRunoffVote.new(vote_array).result.winners[0] )
  end
  
  def test_irv_logic_empty
    vote_array = Array.new
    assert_nil InstantRunoffLogicVote.new(vote_array).result.winners[0]
    assert_equal(false, InstantRunoffLogicVote.new(vote_array).result.winner?)
  end
  
  def test_irv_logic1
    vote_array = Array.new
    42.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    15.times {vote_array << "DCBA".split("")}

    assert_equal( "B", InstantRunoffLogicVote.new(vote_array).result.winners[0] )
  end
  ###TODO: test all the other variants
end

