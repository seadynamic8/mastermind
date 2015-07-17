require 'spec_helper'

module Mastermind
	describe Game do

		context "#initialize" do
			it "set the computer as default player" do
				game = Game.new
				expect(game.player).to eq Player.new(role: :computer)
			end
		end

	end
end