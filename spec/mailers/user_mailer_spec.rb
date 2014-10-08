require "spec_helper"

describe UserMailer do

  describe "#password_reset" do
    before do
      @user = FactoryGirl.create(:user)
      @user.generate_password_reset_token
    end
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("To reset your password, click the URL below.")
    end
  end

  describe "#confirm_email" do
    before do
      @user = FactoryGirl.create(:user_without_email_confirmation) # czemu to nie działa??
      @user.generate_activation_token
    end
    let(:mail) { UserMailer.confirm_email(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Email confirmation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("To confirm your email, click the URL below.")
    end
  end

end
