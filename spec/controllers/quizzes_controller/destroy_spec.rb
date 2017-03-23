require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#destroy" do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz, user: user) }
    let(:params) { { id: quiz.id } }

    before do
      authenticate_user user
      quiz.questions << create(:single_choice_question)
      quiz.questions << create(:single_choice_question)
    end

    it "destroys the quiz and all associated records" do
      expect { delete :destroy, params: params }
        .to change { Quiz.count }.by(-1)
        .and change { Questions::SingleChoice.count }.by(-2)
    end
  end
end
