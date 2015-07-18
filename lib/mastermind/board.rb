module Mastermind
	class Board
		attr_accessor :code, :scores, :turns, :matches, :similars

		def initialize(args = {})
			@code     = args.fetch(:code, generate_code)
			@scores   = {user: 0, computer: 0}
			@turns    = []
			@matches  = {}
			@similars = []
		end

		def display
			puts ""
			show_turns
			show_scores
			puts ""
		end

		def compare_codes(guess)
			result = []

			self.matches = exact_matches(guess)
			matches.each { result << :black }

			self.similars = correct_but_wrong_position(guess)
			similars.each { result << :white }

			self.turns << {guess: guess, result: result}
		end

		def codes_match(guess)
			(guess == code) ? true : false
		end

		def guess_code
			if matches.empty?
				generate_code
			else
				4.times.reduce([]) do |guess, index|
					if matches.keys.include? index
						guess[index] = matches[index]
					elsif not similars.empty?
						guess[index] = similars.shuffle.shift
					else
						guess[index] = random_slot
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
			puts "Score = User: #{@scores[:user]} Computer: #{@scores[:computer]}"
		end

		def exact_matches(guess)
 			code.each.with_index.reduce({}) do |matches, (slot, pos)|
				matches[pos] = slot if slot == guess[pos]
				matches
			end
		end

		def correct_but_wrong_position(guess)
			rest_of_code_to_check = (code - matches.values)
			rest_of_code_to_check & guess
		end

		def generate_code
			4.times.reduce([]) { |code| code << random_slot }
		end

		def random_slot
			rand(6) + 1
		end
	end
end