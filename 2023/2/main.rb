
# file = File.open "samples#{File::SEPARATOR}part_one.txt"
file = File.open 'input.txt'


module Game
  def self.colors
    [:red, :green, :blue]
  end

  def self.cubes_amount
    { red: 12, green: 13, blue: 14 }
  end

  def self.init_game line
    line.split(': ').last.split('; ').map do |hand|
      hand.split(', ').reduce Hash.new do |hash, cubes|
        cube_amount, cube_color = cubes.split

        hash.update cube_color.to_sym => cube_amount.to_i
      end
    end
  end

  def self.is_game_possible? game
    game.all? { |hand| is_hand_possible? hand }
  end

  def self.is_hand_possible? hand
    return Game.colors.all? do |color|
      next true if hand[color].nil?

      hand[color] <= cubes_amount[color]
    end
  end
end

games = file.readlines.map { |line| Game.init_game line }
results = games.map { |game| Game.is_game_possible? game }
valid_games_ids = results.map.with_index { |result, index| result ? index + 1 : 0 }

puts valid_games_ids.sum
