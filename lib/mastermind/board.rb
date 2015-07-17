module Mastermind
	class Board
		attr_reader :code, :scores
		attr_accessor :turns

		def initialize(args = {})
			@code   = args.fetch(:code, default_code)
			@scores = [0, 0]
			@turns = []
			puts "Default Code: #{code.inspect}"
		end

		def display
			puts ""
			show_turns
			show_scores
			puts ""
		end

		def show_turns
			turns.each do |turn|
				puts "Guess: #{turn[:guess].inspect} Result: #{turn[:result].inspect}"
			end
		end
		
		def show_scores
			puts "Score = Player1: #{@scores[0]} Player2: #{@scores[1]}"
		end

		def compare_codes(guess)
			result = []

			matches = find_matches(guess)
			matches.each { result << :black }

			rest = code - matches
			uniq_similars = rest & guess
			uniq_similars.each { result << :white }

			self.turns << {guess: guess, result: result}
			self.scores[1] += 1

			(guess == code) ? true : false
		end

		private


		def find_matches(guess)
 			code.each.with_index.reduce([]) do |matches, (slot, pos)|
				matches << slot if slot == guess[pos]
				matches
			end
		end

		def default_code
			4.times.reduce([]) do |code|
				rand_num = rand(6) + 1
				code << rand_num
			end
		end
	end
end