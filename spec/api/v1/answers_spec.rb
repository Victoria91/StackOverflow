require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 5, question: question) }
  let(:answer) { answers.first }

  describe 'GET/index' do
    let(:success_status) { 200 }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API authenticable'

    before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

    it 'returns list of answers' do
      expect(response.body).to have_json_size(5).at_path('answers')
    end

    %w(id body question_id created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
      end
    end

    def send_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET/answer/id' do
    let(:access_token) { create(:access_token) }
    let(:success_status) { 200 }

    it_behaves_like 'API authenticable'

    before { get "/api/v1/answers/#{answers.first.id}", format: :json, access_token: access_token.token }

    %w(id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path ("answer/#{attr}")
      end
    end

    def send_request(options = {})
      get "/api/v1/answers/#{answers.first.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST/answers' do
    let(:success_status) { 201 }
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API authenticable'

    context 'with valid attributes' do
      it 'creates answer' do
        expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: 'body' } }.to change(user.answers, :count).by(1)
      end

      %w(id body body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: 'body' }
          answer = assigns(:answer)
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end

    context 'with invalid attributes' do
      it 'returns :unprocessable_entity status' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: '' }
        expect(response.status).to eq(422)
      end

      it 'not creates question' do
        expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: '' } }.not_to change(Answer, :count)
      end

      it 'returns errors' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: '' }
        expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
      end
    end

    def send_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json, answer: { body: 'body' } }.merge(options)
    end
  end
end
