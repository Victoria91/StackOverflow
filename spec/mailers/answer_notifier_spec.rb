require "rails_helper"

RSpec.describe AnswerNotifier, :type => :mailer do
  describe "author" do
    let(:mail) { AnswerNotifier.author }

    xit "renders the headers" do
      expect(mail.subject).to eq("Author")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "subscribers" do
    let(:mail) { AnswerNotifier.subscribers }

    xit "renders the headers" do
      expect(mail.subject).to eq("Subscribers")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
