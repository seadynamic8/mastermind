module Mastermind
	class Player
		attr_reader :role

		def initialize(args = {})
			@role = args.fetch(:role)
		end
	end
end