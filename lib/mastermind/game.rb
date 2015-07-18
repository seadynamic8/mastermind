module Mastermind
	class Game
		attr_reader :board
		attr_accessor :player, :role
		
		def initialize(args = {})
			@role = :breaker
			@board  = args.fetch(:board, Board.new)
			@player = :user
		end

		def play
			puts "Welcome to Mastermind!"
			puts ""
			self.role = get_initial_role
			loop do
				board.code = get_code if role == :maker
				play_round(role)
				change_player
				change_role
				break unless next_round_or_quit
			end
		end

		private

		def get_initial_role
			puts "Role: codebreaker(1) or codemaker(2) or quit(q): "
			role = gets.chomp
			case role
			when "1"
				:breaker
			when "2"
				self.player = :computer
				:maker
			else
				exit
			end
		end

		def next_round_or_quit
			puts "Continue next round(c) or quit(q): "
			case gets.chomp
			when "c"
				true
			else
				exit
			end
		end

		def change_role
			self.role = (role == :breaker) ? :maker : :breaker
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
				board.compare_codes(guess)
				(count == 12) ? increase_other_score(2) : increase_other_score
				board.display
				break if board.codes_match(guess) or count == 12
			end

			print_finish_round(count)
			board.turns = []
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

		def increase_other_score(amount = 1)
			if player == :user
				board.scores[:computer] += amount
			else
				board.scores[:user] += amount
			end
		end

		def print_finish_round(count)
			if count == 12
				puts "Sorry, #{player} ran out of tries."
			else
				puts "#{player.to_s.capitalize}: Won this round."
			end
			puts ""
		end

		def change_player
			self.player = (player == :user) ? :computer : :user
		end

		def correct_range?(guess)
			guess.all? {|slot| (1..6).include?(slot) }
		end

	end
end