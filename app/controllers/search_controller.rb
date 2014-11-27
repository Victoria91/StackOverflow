class SearchController < ApplicationController
  def find
    @questions = Question.search Riddle::Query.escape(params[:search][:query])
  end
end
