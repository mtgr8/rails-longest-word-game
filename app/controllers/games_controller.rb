class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    attempt_grid_verify(@word, ["D","O","N","T"])
    attemp_result(@word)
    run_game(@word, ["D","O","N","T"])
  end
end

def attempt_grid_verify(attempt, grid)
  attempt.upcase.gsub(" ", "").chars.each do |letter|
    return false unless grid.include?(letter)

    grid.delete_at(grid.index(letter))
  end
  return attempt
end

def attemp_result(attempt)
  url = "https://wagon-dictionary.herokuapp.com/dont"
  attempt_result_raw = URI.open(url).read
  JSON.parse(attempt_result_raw)
end

def run_game(attempt, grid)
  # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)

  if !attempt_grid_verify(attempt, grid)
    { score: 0, message: "not in the grid" }
  elsif !attempt_result["found"]
    { score: 0, message: "not an english word" }
  else
    { score: ((attempt_result["length"]) * 10) - time_score, message: "well done" }
  end
end
