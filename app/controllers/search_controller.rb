class SearchController < ApplicationController
  def find
    @questions = Question.search params[:search][:query]
  end
end
