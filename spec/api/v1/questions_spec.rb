require 'rails_helper'

describe 'Questions API' do
  describe 'GET/index' do
    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question, 5) }
    let(:question) { questions.last }
    let!(:answer) { create(:answer, question: question) }
    let(:success_status) { 200 }

    it_behaves_like 'API authenticable'

    before { get '/api/v1/questions', format: :json, access_token: access_token.token }

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

    context 'custom attributes' do
      context 'question author\'s avatar_url' do
        it 'contains user avatar if authorizations present' do
          questions.last.user.authorizations.create(avatar_url: 'avatar_url')
          send_request(access_token: access_token.token)
          expect(response.body).to be_json_eql('avatar_url'.to_json).at_path('questions/0/avatar_url')
        end

        it 'contains \'photo.png\' if there is no authorizations' do
          send_request(access_token: access_token.token)
          expect(response.body).to be_json_eql(ActionController::Base.helpers.asset_path('user.png').to_json).at_path('questions/0/avatar_url')
        end
      end

      it 'contains human date' do
        send_request(access_token: access_token.token)
        expect(response.body).to be_json_eql(question.created_at.strftime('%B %d, %Y, %A').to_json).at_path('questions/0/created_at_to_human')
      end

    end

    def send_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET/questions/id' do
    let(:question) { create(:question) }
    let!(:attachment) { create(:attachment, attachmentable_type: 'Question', attachmentable_id: question.id) }
    let(:access_token) { create(:access_token) }
    let(:success_status) { 200 }

    it_behaves_like 'API authenticable'

    before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

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
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/file/url')
      end
    end

    def send_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:success_status) { 201 }

    it_behaves_like 'API authenticable'

    context 'with valid attributes' do
      it 'creates question' do
        expect { post '/api/v1/questions', format: :json, access_token: access_token.token, question: { title: 'question\'s title', body: 'question\'s body' } }.to change(user.questions, :count).by(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: { title: 'question\'s title', body: 'question\'s body' }
          question = assigns(:question)
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end

    context 'with invalid attributes' do
      it 'returns :unprocessable_entity status' do
        post 'api/v1/questions', format: :json, access_token: access_token.token, question: { body: 'body' }
        expect(response.status).to eq(422)
      end

      it 'not creates question' do
        expect { post '/api/v1/questions', format: :json, access_token: access_token.token, question: { body: 'body' } }.not_to change(Question, :count)
      end

      it 'returns errors' do
        post '/api/v1/questions', format: :json, access_token: access_token.token, question: { body: 'body' }
        expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0')
      end
    end

    def send_request(options = {})
      post '/api/v1/questions', { format: :json, question: { title: 'question\'s title', body: 'question\'s body' } }.merge(options)
    end
  end
end
