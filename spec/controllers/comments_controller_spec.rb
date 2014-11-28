require 'rails_helper' 

RSpec.describe CommentsController do
  describe 'POST #create' do
    let(:question) { create(:question) }
    
    context 'authorized' do
      sign_in_user

      it 'creates comment related to a question and user' do
        expect{ post :create, comment: { body: 'comment body' }, question_id: question }.to change( question.comments.where(user: @user), :count).by(1)
      end
      
      it 'renders create template' do
        post :create, comment: { body: 'comment body' }, question_id: question
        expect(response).to render_template :create
      end
    end

    context 'unauthorized' do
      it 'not create comment' do
        expect{ post :create, comment: { body: 'comment body' }, question_id: question }.to change(Comment, :count)
      end
    end
  end
  
end