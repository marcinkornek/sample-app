require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    before do
      @user = FactoryGirl.create(:user)
      @user.generate_password_reset_token
    end
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do
      mail.subject.should eq("Password reset")
      mail.to.should eq([@user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("To reset your password, click the URL below.")
    end
  end

end
