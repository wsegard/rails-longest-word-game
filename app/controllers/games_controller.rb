require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    8.times { @letters << [*('A'..'Z')].sample(1).join }
    @letters
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    serialized_word = open(url).read
    word_object = JSON.parse(serialized_word)
    if word_object['found'] == false
      @result = "#{@word.upcase} does not exist"
    elsif incl(@word, @letters.gsub(' ','')) == false
      @result = "#{@word.upcase} can't be built out of #{@letters}"
    else
      session[:score] = session[:score] + word_object['length'].to_i
      @score = session[:score]
      @result = "Congratulations!, #{@word.upcase} is a valid english word!"
    end
  end

  def incl(attempt, grid)
    attempt_hash = Hash.new(0)
    grid_hash = Hash.new(0)
    attempt.downcase.chars.each { |x| attempt_hash[x] += 1 }
    grid.downcase.chars.each { |x| grid_hash[x] += 1 }
    result = []
    attempt_hash.each do |key, value|
      if grid_hash.key?(key) && value <= grid_hash[key]
        result << true
        else result << false
      end
    end
    if result.include?(false)
      return false
    else true
    end
  end
end
