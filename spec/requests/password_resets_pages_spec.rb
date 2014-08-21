require 'spec_helper'

describe "Password Resets pages" do

subject { page }

  describe 'reset password page' do
    before do
      @user = FactoryGirl.create(:user, email: "valid_email@email.com")
      visit password_resets_new_path
    end

    it { should have_title('Reset Password') }
    it { should have_content('Reset Password') }

    describe 'with invalid email' do
      before do
        fill_in "Email", with: "invalid_email@email.com"
        click_button "Reset Password"
      end
      it { expect(current_path).to eq(root_path) }
      it { should have_selector('div.alert.alert-success', text: 'Email sent with password reset instructions.') }
    end

    describe 'with valid email' do
      before do
        # puts page.html
        fill_in "Email", with: "valid_email@email.com"
        click_button "Reset Password"
      end
      it { expect(current_path).to eq(root_path) }
      it { should have_selector('div.alert.alert-success', text: 'Email sent with password reset instructions.') }
    end

  end



end
