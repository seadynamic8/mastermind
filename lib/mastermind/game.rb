module Mastermind
	class Game
		attr_reader :board
		attr_accessor :player, :role
		
		def initialize(args = {})
			@role = :breaker
			@board  = args.fetch(:board, Board.new)
		end

		def play
			puts "Welcome to Mastermind!"
			puts ""

			loop do
				self.role = get_player_role

				break if role == :quit

				board.code = get_code if role == :maker
				play_round(role)
			end
		end

		private

		def get_player_role
			puts "Role: codebreaker(1) or codemaker(2) or quit(q): "
			role = gets.chomp
			case role
			when "1"
				:breaker
			when "2"
				:maker
			else
				:quit
			end
		end

		def get_code
			puts "Secret code (1 to 6, seperated by spaces, 4 slots): "
			gets.chomp.split(" ").map(&:to_i)
		end

		def play_round(role)
			count = 0
			loop do
				count +=1
				guess = (role == :maker) ? board.guess_code : get_guess
				break if board.compare_codes(guess) or count == 12
				board.display
			end

			print_finish_round(count)
		end

		def get_guess
			guess = []
			loop do
				print "Your guess: "
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

		def print_finish_round(count)
			if count == 12
				puts "Sorry, you ran out of tries"
			else
				puts "Won this round."
			end
			board.display
			board.turns = []
		end

		def correct_range?(guess)
			guess.all? {|slot| (1..6).include?(slot) }
		end

	end
end