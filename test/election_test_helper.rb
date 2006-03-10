$:.unshift(File.dirname(__FILE__) + "/../lib/")

require 'rubyvote'

module ElectionTestHelper
  def test_winner(expected, result) 
    puts "\nUsing the #{result.class.to_s.gsub(/Result/,'')} voting method..."

    if result.winner?
      if expected.is_a?(Array) && expected.length > 1 # Array is passed to test for a tie!
        msg = "There is a tie: %s" % result.winners.join(", ")

        assert_equal(expected.length, result.winners.length, 
                     "Not the correct number of winners!")
        assert(expected.all?{|c| result.winners.include?(c)}, 
               "Tie winners do not match expected!")
      else 
        msg = "There is a single winner: #{result.winners[0]}"
        assert_equal(expected, result.winners[0], msg) 
      end

    else
      msg = "There is no winner"
      assert_nil(expected, msg)
    end

    puts msg
  end
end
