require 'rails_helper' 

RSpec.describe CommentsController do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Question' do
      context 'authorized' do
        sign_in_user

        it 'loads question' do
          post :create, comment: { body: 'comment body' }, question_id: question, format: :js
          expect(assigns(:parrent)).to eq(question)
        end

        it 'creates comment related to a question and user' do
          expect{ post :create, comment: { body: 'comment body' }, question_id: question, format: :js }.to change( question.comments.where(user: @user), :count).by(1)
        end
        
        it 'renders create template' do
          post :create, comment: { body: 'comment body' }, question_id: question, format: :js
          expect(response).to render_template :create
        end
      end

      context 'unauthorized' do
        it 'not create comment' do
          expect{ post :create, comment: { body: 'comment body' }, question_id: question, format: :js }.not_to change(Comment, :count)
        end
      end
    end

    context 'Answer' do
      let(:answer) { create(:answer, question: question) }

      xit 'loads Answer' do
        post :create, comment: { body: 'comment body' }, answer_id: answer, format: :js
        expect(assigns(:parrent)).to eq(answer)
      end        
    end
  end
  
end