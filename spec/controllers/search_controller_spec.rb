require 'rails_helper'

RSpec.describe SearchController do

  describe "GET find" do
    it "call search on Question model" do
      expect(Question).to receive(:search).with 'query'
      get :find, search: { query: 'query' }
    end
  end

end
