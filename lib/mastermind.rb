require_relative "mastermind/version"
require_relative "mastermind/game"
require_relative "mastermind/board"

module Mastermind
  game = Game.new
  game.play
end
