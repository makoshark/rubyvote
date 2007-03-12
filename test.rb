#!/usr/bin/ruby -I./lib

# election library -- a ruby library for elections
# copyright © 2005 MIT Media Lab and Benjamin Mako Hill

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

require 'test/unit'
require 'lib/rubyvote'

class TestRubyvote < Test::Unit::TestCase

  def test_condorcet
    vote_array = Array.new
    3.times {vote_array << "ABC".split("")}
    3.times {vote_array << "CBA".split("")}
    2.times {vote_array << "BAC".split("")}

    assert_equal 'B', PureCondorcetVote.new(vote_array).result.winners[0][0]
  end

  def test_ssd_1
    vote_array = Array.new
    5.times {vote_array << "ACBED".split("")}
    5.times {vote_array << "ADECB".split("")}
    8.times {vote_array << "BEDAC".split("")}
    3.times {vote_array << "CABED".split("")}
    7.times {vote_array << "CAEBD".split("")}
    2.times {vote_array << "CBADE".split("")}
    7.times {vote_array << "DCEBA".split("")}
    8.times {vote_array << "EBADC".split("")}

    assert_equal 'E', CloneproofSSDVote.new(vote_array).result.winners[0]
  end

  def test_ssd_2
    vote_array = Array.new
    5.times {vote_array << "ACBD".split("")}
    2.times {vote_array << "ACDB".split("")}
    3.times {vote_array << "ADCB".split("")}
    4.times {vote_array << "BACD".split("")}
    3.times {vote_array << "CBDA".split("")}
    3.times {vote_array << "CDBA".split("")}
    1.times {vote_array << "DACB".split("")}
    5.times {vote_array << "DBAC".split("")}
    4.times {vote_array << "DCBA".split("")}

    assert_equal 'D', CloneproofSSDVote.new(vote_array).result.winners[0]
  end

  def test_ssd_3
    vote_array = Array.new
    3.times {vote_array << "ABCD".split("")}
    2.times {vote_array << "DABC".split("")}
    2.times {vote_array << "DBCA".split("")}
    2.times {vote_array << "CBDA".split("")}

    assert_equal 'B', CloneproofSSDVote.new(vote_array).result.winners[0]
  end

  def test_borda
    vote_array = Array.new
    3.times {vote_array << "ABC".split("")}
    3.times {vote_array << "CBA".split("")}
    2.times {vote_array << "BAC".split("")}

    assert_equal 'B', BordaVote.new(vote_array).result.winners[0]
  end

  def test_plurality
    vote_array = "ABCABCABCCCBBAAABABABCCCCCCCCCCCCCA".split("")

    assert_equal 'C', PluralityVote.new(vote_array).result.winners[0]
  end

  def test_approval
    vote_array = Array.new
    10.times {vote_array << "AB".split("")}
    10.times {vote_array << "CB".split("")}
    11.times {vote_array << "AC".split("")}
    5.times {vote_array << "A".split("")}

    assert_equal 'A', ApprovalVote.new(vote_array).result.winners[0] 
  end

  def test_irv_1
    vote_array = Array.new
    142.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    17.times {vote_array << "DCBA".split("")}

    assert_equal 'A', InstantRunoffVote.new(vote_array).result.winners[0]
  end

  def test_irv_2
    vote_array = Array.new
    42.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    17.times {vote_array << "DCBA".split("")}

    assert_equal 'D', InstantRunoffVote.new(vote_array).result.winners[0]
  end

  def test_irv_3
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

    assert_equal 'C', InstantRunoffVote.new(vote_array).result.winners[0]
  end

  def test_irvlogic
    vote_array = Array.new
    42.times {vote_array << "ABCD".split("")}
    26.times {vote_array << "BCDA".split("")}
    15.times {vote_array << "CDBA".split("")}
    15.times {vote_array << "DCBA".split("")}

    assert_equal 'B', InstantRunoffLogicVote.new(vote_array).result
  end

  def test_range1
    vote_array = Array.new
    42.times {vote_array << {:A => 10, :B => 5, :C => 2, :D => 1}}
    26.times {vote_array << {:A => 1, :B => 10, :C => 5, :D => 2}}
    15.times {vote_array << {:A => 1, :B => 2, :C => 10, :D => 5}}
    17.times {vote_array << {:A => 1, :B => 2, :C => 5, :D => 10}}

    assert_equal 'B', RangeVote.new(vote_array).result
  end

end
