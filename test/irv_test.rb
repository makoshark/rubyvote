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
 
  def test_irv4
    # this was causing selectricity to crash

    raw_vote_array = ["GFECADBIH", "ABCDEFGHI", "IGHBADFCE",
                      "FABCDEGHI", "ABCDEFGHI", "ABCDEFGHI",
                      "ABCDEFGHI", "ABCDEFGHI", "ABCDEFGHI",
                      "EHBICDAGF", "ECGDFBIAH", "BDHIGFECA",
                      "ECDBFIHAG", "FEDBCAHIG", "CDABHIEFG",
                      "FCBDIHAEG", "AIHFBECGD", "BACHDEFIG",
                      "CDEFIBHAG", "BDICAFEGH", "ABCDEFGHI",
                      "CBIHDFAEG", "ABCDEFGHI", "CDFIBAGEH",
                      "ECDBIFHGA", "BDACEHFIG", "CFDIHABEG",
                      "ADCFGBIHE", "CDHIBEAGF", "ABCFDHIEG",
                      "ABCDEFGHI", "DCFHIBAGE", "CDFEABHIG",
                      "DFHIBEAGC", "EDCBFIGAH", "BAECDFHGI",
                      "BAHCEDFGI", "HBCDIAFEG", "ABCDEFGHI",
                      "ABCDEFGHI", "EDCBIGAHF", "EIBDCGAFH",
                      "HIACGDFBE", "DEACBIFGH", "CIDEFABGH",
                      "ABHDIECGF", "ECIDBFGHA", "CEDFBHIGA",
                      "ABHCEIDFG", "CFDBEIHGA", "ICEDBGFAH",
                      "EDCIFBAGH", "ECFDBAHGI", "EBCADFIGH",
                      "EFBHAGICD", "CDBIEFAHG", "ABCDEFGHI",
                      "FCDBEIHGA", "AIEBDCFHG", "CDFEBIGAH",
                      "CABDEFGHI", "DCEIBFGHA", "EADCIBHFG",
                      "DBCAHIGEF", "EDFBCIAHG", "EDCBIHAGF",
                      "CFIAEDGHB", "CDEIHABGF", "CEBHIDAFG",
                      "BCFEDIHAG", "CDIHBFGEA", "CFEDIGBAH",
                      "IHFEADCBG", "EBDCIGAHF", "BCEDFIAGH",
                      "ABHEGICDF", "CABFHDIEG", "HEABDCFGI",
                      "CDEBFAIHG", "CDBFIHAGE", "ABGFEDHCI",
                      "IBHDCAEFG", "EBDICHAFG", "ABCDEFGHI",
                      "EFBHAICGD", "CBDFHAIEG", "CDBAEIHGF",
                      "ABCDEFGHI", "BECDHIFGA", "DAGCIHFBE",
                      "BIECDGAHF", "ABCDEFGHI", "ACDEBHIFG",
                      "AEBCIDHFG", "ABCDEFGHI", "ABCDEFGHI",
                      "ABCDEFGHI", "ABCDEFGHI", "ABCDEFGHI",
                      "ABCDEFGHI", "ECFDIHBAG", "BIDCHEAGF",
                      "BCEDFIGHA", "CBDAFEGHI", "ABCDEFGHI",
                      "FACEGDHBI", "ABCDEFGHI", "FDIBCGHAE",
                      "EBIHADCFG", "EDBIHAGCF", "AHDICBFEG",
                      "DCBIHAGFE", "CABFIDEHG", "IFCBHADEG",
                      "EDCFHIBAG", "DCABEFGHI", "FCBDIGHEA",
                      "ABCDEFGHI", "HBACIDEFG", "ABCDEFGHI",
                      "ABCDEFGHI", "EADCBIHGF", "BDCIHAGFE",
                      "ABCDEFGHI", "ABCDEFGHI", "ABCDEFGHI",
                      "ABCDEFGHI", "ABCDEFGHI", "ICDGAHBEF",
                      "EGBCFIHDA", "DFGACHIEB", "BCAGDFHIE",
                      "DBGHCEAFI", "IGHEBCADF", "FEDIHBCAG",
                      "HAICBGEFD", "EBFDAICGH", "ECGAHFIBD",
                      "GEFICAHDB", "ACEHGIBDF", "EGIFBHCAD",
                      "GHFEDCIBA", "DGAEHFICB", "HGDICBAFE",
                      "HEACGDBFI", "IAGDFHCEB", "EGIACHBDF",
                      "CBFGDIEAH", "CGAIBDEFH", "AHEDIGCBF",
                      "BAEFHIDCG", "BIDGAFCHE", "CHBAEDFIG",
                      "IBGCFADEH", "GHACDEFIB", "CFDBEAHIG",
                      "GDEFAICHB"]
    vote_array = raw_vote_array.collect {|v| v.split("")}
    print InstantRunoffVote.new(vote_array).result.winners, "\n"
    assert_equal(true, InstantRunoffVote.new(vote_array).result.winner?)
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

