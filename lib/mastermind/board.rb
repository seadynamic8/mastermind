module Mastermind
	class Board
		attr_accessor :code, :scores, :turns, :matches

		def initialize(args = {})
			@code   = args.fetch(:code, generate_code)
			@scores = [0, 0]
			@turns = []
			@matches = {}
		end

		def display
			puts ""
			show_turns
			show_scores
			puts ""
		end

		def compare_codes(guess)
			result = []

			self.matches = find_matches(guess)
			matches.each { |slot| result << :black }

			rest = code - matches.values
			uniq_similars = rest & guess
			uniq_similars.each { result << :white }

			self.turns << {guess: guess, result: result}
			self.scores[1] += 1

			(guess == code) ? true : false
		end

		def guess_code
			if matches.empty?
				generate_code
			else
				4.times.reduce([]) do |guess, index|
					if matches.keys.include? index
						guess[index] = matches[index]
					else
						guess[index] = rand(6) + 1
					end
					guess
				end
			end
		end

		private

		def show_turns
			turns.each.with_index do |turn, index|
				print "#{index + 1}.".ljust(4)
				puts "Guess: #{turn[:guess].inspect} "\
						 "Result: #{turn[:result].inspect}"
			end
		end
		
		def show_scores
			puts "Score = Player1: #{@scores[0]} Player2: #{@scores[1]}"
		end

		def find_matches(guess)
 			code.each.with_index.reduce({}) do |matches, (slot, pos)|
				matches[pos] = slot if slot == guess[pos]
				matches
			end
		end

		def generate_code
			4.times.reduce([]) do |code|
				rand_num = rand(6) + 1
				code << rand_num
			end
		end
	end
end