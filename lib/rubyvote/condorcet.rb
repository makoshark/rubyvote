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

#################################################################
## ==== condorcet.rb ====
##
## This file contains Condorcet election methods. Currently this
## includes a pure condorcet and a CloneproofSSD implementation
## modeled after the Python-based Debian project election code and
## that gives the same results in several tested corner cases.
#################################################################

##################################################################
## CondorcetVote Classes and SubClasses
##
## The CondorcetVote class is subclassed by the PureCondorcetVote and
## the CloneproofSSDVote classes but should not be used directly.

class CondorcetVote < ElectionVote

  def initialize(votes=nil)
    unless defined?(@candidates)
      @candidates = Array.new
      votes.each do |vote_row|
        vote_row = vote_row.flatten if vote_row.class == Array
        vote_row.each do |vote| 
          @candidates << vote unless @candidates.include?(vote)
        end
      end
    end
    super(votes)
  end

  def tally_vote(vote=nil)

    vote.each_with_index do |winner, index|
      if vote.flatten.length < @candidates.length
        implied_losers = @candidates.select { |c| not vote.include?(c) }
        vote.push(implied_losers)
      end
      if vote.length - 1 == index
        losers = []
      else
        losers = vote.flatten.last( vote.flatten.length - index - 1)
      end

      losers.each do |place|
        place = [place] unless place.class == Array
        place.each do |loser|
          

          @votes[winner] = Hash.new unless @votes.has_key?(winner)
          @votes[loser] = Hash.new unless @votes.has_key?(loser)

          if @votes[winner].has_key?(loser)
            @votes[winner][loser] += 1
          else
            @votes[winner][loser] = 1
          end

          # make sure we have a comparable object
          @votes[loser][winner] = 0 unless @votes[loser].has_key?( winner )
        end
      end
    end
  end

  def result
    resultFactory( self )
  end

  protected
  def verify_vote(vote=nil)
    vote.instance_of?( Array ) and
      vote == vote.uniq
  end

end

class PureCondorcetVote < CondorcetVote
  def resultFactory(init)
    PureCondorcetResult.new(init)
  end
end

class CloneproofSSDVote < CondorcetVote
  def resultFactory(init)
    CloneproofSSDResult.new(init)
  end

  def result
    top_result = resultFactory( self )
    until @candidates.empty?
      aResult = resultFactory( self )
      top_result.full_results << aResult
      filter_out(aResult)
    end
    top_result
  end

end


##################################################################
## CondorcetResult Classes and SubClasses
##
## The CondorcetResult class is subclassed by the PureCondorcetResult
## and the CloneproofSSDResult classes but should not be used
## directly.

class CondorcetResult < ElectionResult
  def initialize(voteobj=nil)
    unless voteobj and voteobj.kind_of?( CondorcetVote )
      raise ArgumentError, "You must pass a CondorcetVote array.", caller
    end
    super(voteobj)
  end

  protected
  def defeats(candidates=nil, votes=nil)
    candidates = @election.candidates unless candidates
    votes = @election.votes unless votes

    defeats = Array.new
    candidates = [candidates] unless candidates.class == Array
    candidates.each do |candidate|
      candidates.each do |challenger|
        next if candidate == challenger
        if votes[candidate][challenger] > votes[challenger][candidate]
          defeats << [ candidate, challenger ]
        end
      end
    end

    defeats
  end

end

class PureCondorcetResult < CondorcetResult
  def initialize(voteobj=nil)
    super(voteobj)
    self.condorcet()
  end

  protected
  def condorcet
    votes = @election.votes
    candidates = @election.candidates

    victors = Hash.new
    candidates.each do |candidate|
      victors[candidate] = Array.new
    end

    self.defeats.each do |pair|
      winner, loser = *pair
      victors[winner] << loser
    end

    winners = @election.candidates.find_all do |candidate|
        victors[candidate].length == @election.candidates.length - 1
    end

    @winners << winners if winners.length == 1
  end
end

class CloneproofSSDResult < CondorcetResult
  def initialize(voteobj=nil)
    super(voteobj)
    @winners = self.cpssd()
  end

  protected
  def cpssd
    votes = @election.votes
    candidates = *@election.candidates

    def in_schwartz_set?(candidate, candidates, transitive_defeats)
      candidates.each do |challenger|
        next if candidate == challenger

        if transitive_defeats.include?( [ challenger, candidate ] ) and
            not transitive_defeats.include?( [ candidate, challenger ] )
          return false
        end
      end
      return true
    end

    loop do

      # see the array with the standard defeats
      transitive_defeats = self.defeats(candidates, votes)

      candidates = [candidates] unless candidates.class == Array
      candidates.each do |cand1|
        candidates.each do |cand2|
          candidates.each do |cand3|
            if transitive_defeats.include?( [ cand2, cand1 ] ) and
                transitive_defeats.include?( [ cand1, cand3 ] ) and
                not transitive_defeats.include?( [ cand2, cand3 ] ) and
                not cand2 == cand3
              transitive_defeats << [ cand2, cand3 ]
            end
          end
        end
      end

      schwartz_set = Array.new
      candidates.each do |candidate|
        if in_schwartz_set?(candidate, candidates, transitive_defeats)
          schwartz_set << candidate
        end
      end

      candidates = schwartz_set

      # look through the schwartz set now for defeats
      defeats = self.defeats(candidates, votes)
      
      # it's a tie or there's only one option
      break if defeats.length == 0

      def is_weaker_defeat?( pair1, pair2 )
        votes = @election.votes
        if votes[pair1[0]][pair1[1]] > votes[pair2[0]][pair2[1]]
          return true
        elsif votes[pair1[0]][pair1[1]] == votes[pair2[0]][pair2[1]] and
            votes[pair1[1]][pair1[0]] > votes[pair2[1]][pair2[0]]
          return true
        else
          false
        end
      end
      
      defeats.sort! do |pair1, pair2|
        if is_weaker_defeat?( pair1, pair2 ) 
          +1
        elsif is_weaker_defeat?( pair2, pair1 ) 
          -1
        else
          0
        end
      end
 
      votes[defeats[0][0]][defeats[0][1]] = 0
      votes[defeats[0][1]][defeats[0][0]] = 0
      
    end

    return candidates
  end

end
