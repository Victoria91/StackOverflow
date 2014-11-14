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

      %w(id body question_id created_at updated_at).each do |attr|
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

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path ("answer/#{attr}")
        end
      end
    end
  end

  describe 'POST/answers' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end

    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: 'body' }
          expect(response.status).to eq(201)
        end

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
        it 'returns 200 status' do
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
    end
  end
end
