require 'rails_helper' 

describe 'Answers API' do
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 5, question: question) }
  let(:answer) { answers.first }

  describe 'GET/index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(5).at_path('answers')
      end

      %w(id body question_id created_at updated_at user_id accepted).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET/answer/id' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answers.first.id}", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if there access_token is invalid' do
        get "/api/v1/answers/#{answers.first.id}", format: :json, access_token: '13133'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/answers/#{answers.first.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      %w(id body created_at updated_at user_id accepted).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path ("#{attr}")
        end
      end
    end
  end
end