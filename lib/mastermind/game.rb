module Mastermind
	class Game
		attr_reader :player, :board
		
		def initialize(args = {})
			@player = args.fetch(:player, Player.new(role: :computer))
			@board  = args.fetch(:board, Board.new(code: [1, 1, 2, 2]))
		end

		def play
			puts "Welcome to Mastermind!"
			puts ""

			count = 0
			loop do
				count +=1
				guess = get_guess
				break if board.compare_codes(guess) or count == 12
				board.display
			end

			if count == 12
				puts "Sorry, you ran out of tries"
			else
				puts "Won this round."
				board.show_scores
			end

		end

		private

		def get_guess
			guess = []
			loop do
				print "Code to test: "
				guess = gets.chomp.split(" ").map(&:to_i)
				if correct_range?(guess) and guess.size == 4
					break
				elsif not correct_range?(guess)
					puts "Guesses have to be between 1 and 6"
				elsif guess.size != 4
					puts "You need to have 4 slots to guess"
				end
			end
			guess
		end

		def correct_range?(guess)
			guess.all? {|slot| (1..6).include?(slot) }
		end
	end
end