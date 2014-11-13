require 'rails_helper'

describe 'Questions API' do
  describe 'GET/index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status with valid token' do
        expect(response.status).to eq(200)
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(5).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'returns answers' do
        expect(response.body).to have_json_size(1).at_path('questions/0/answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET/questions/id' do
    let(:question) { create(:question) }
    let!(:attachment) { create(:attachment, attachmentable_type: 'Question', attachmentable_id: question.id ) }
    
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end

    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'attachment' do
        it 'returns attachment' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it 'context file url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file/url")
        end
      end
    end
  end
end
