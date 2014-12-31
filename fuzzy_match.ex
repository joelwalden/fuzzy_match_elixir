defmodule FuzzyMatch do
  def match(input, word_list) do
    downcased_words = Enum.map(word_list, fn(x) -> String.downcase(x) end)
    FuzzyMatch.match(String.downcase(input), downcased_words, {"", 0}) 
  end

  def match(_, [], {best_match, _}) do
    best_match
  end

  def match(input, word_list, {best_match, match_score}) do
    word = Enum.at(word_list, 0)
    score = FuzzyMatch.score(input, word)

    new_list = List.delete_at(word_list, 0)

    if score > match_score do
      FuzzyMatch.match(input, new_list, {word, score})
    else
      FuzzyMatch.match(input, new_list, {best_match, match_score})
    end
  end

  def score(input, word) do
    input_pairs = FuzzyMatch.make_pairs(input)
    word_pairs = FuzzyMatch.make_pairs(word)

    num_bigrams = Enum.count(input_pairs) + Enum.count(word_pairs)

    score(input_pairs, word_pairs, 0, num_bigrams)
  end

  def score([], _, matched, num_bigrams) do
    (2 * matched) / num_bigrams
  end

  def score(input_pairs, word_pairs, matched, num_bigrams) do
    if Enum.member?(word_pairs, Enum.at(input_pairs, 0)) do
      found = 1
    else
      found = 0
    end

    new_matched = matched + found
    new_input = List.delete_at(input_pairs, 0)

    score(new_input, word_pairs, new_matched, num_bigrams)

  end

  def make_pairs(word) do
    make_pairs(word, [])
  end

  def make_pairs("", pairs) do
    return_val = List.delete_at(pairs, -1)
    return_val
  end

  def make_pairs(word, pairs) do
    new_pairs = List.insert_at(pairs, -1, [String.at(word, 0), String.at(word, 1)])
    make_pairs(String.slice(word, 1..-1), new_pairs)
  end
end

