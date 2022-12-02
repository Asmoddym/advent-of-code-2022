data = File.read("input.txt")

@rules = [
  {
    hand: ['A', 'X'],
    wins_on: ['C', 'Z'],
    loses_on: ['B', 'Y'],
    additional_value: 1
  },
  {
    hand: ['B', 'Y'],
    wins_on: ['A', 'X'],
    loses_on: ['C', 'Z'],
    additional_value: 2
  },
  {
    hand: ['C', 'Z'],
    wins_on: ['B', 'Y'],
    loses_on: ['A', 'X'],
    additional_value: 3
  }
]

def get_hand_rules(hand)
  @rules.select { |rule| rule[:hand].include?(hand) }.first
end

def is_draw?(opponent_hand, player_hand)
  opponent_hand[:hand] == player_hand[:hand]
end

def is_lost?(opponent_hand, player_hand)
  opponent_hand[:wins_on] == player_hand[:hand]
end

def calculate_score_for_round_part_1(hands)
  opponent_hand = get_hand_rules(hands.first)
  player_hand = get_hand_rules(hands.last)

  score = player_hand[:additional_value]

  return score + 3 if is_draw?(opponent_hand, player_hand)
  return score if is_lost?(opponent_hand, player_hand)

  score + 6
end

def calculate_score_for_round_part_2(hands)
  opponent_hand = get_hand_rules(hands.first)

  case hands.last
  when 'X'
    score = 0
    player_hand = get_hand_rules(opponent_hand[:wins_on].first)
  when 'Y'
    score = 3
    player_hand = get_hand_rules(hands.first)
  when 'Z'
    score = 6
    player_hand = get_hand_rules(opponent_hand[:loses_on].first)
  end

  score + player_hand[:additional_value]
end

results = data.split("\n").each_with_object({ part_1: 0, part_2: 0 }) do |round, aggr|
  hands = round.split(' ')

  aggr[:part_1] += calculate_score_for_round_part_1(hands)
  aggr[:part_2] += calculate_score_for_round_part_2(hands)
end

puts results[:part_1]
puts results[:part_2]
