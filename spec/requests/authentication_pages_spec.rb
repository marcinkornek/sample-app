require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_content('Remember me') }
    it { should have_link('forgotten password?', href: password_resets_new_path) }
    it { should have_title('Sign in') }
  end

   describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }
      it { expect(page).not_to have_css("img[src*='feed-icon-28x28.png']")}

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information", focus: true do
      context 'After email confirmation' do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }

        it { should have_title(user.name) }
        it { should have_link('Users',       href: users_path) }
        it { should have_link('Profile',     href: user_path(user)) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
        it { should have_link('Sign out',    href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }
        it { expect(page).to have_css("img[src*='feed-icon-28x28.png']")}
        it { expect(find("#rss")['href']).to eq(rss_path(user.rss_token)) }


        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end

        describe "when attempting to visit signup page" do
          before { visit signup_path }
          it { expect(current_path).to eq(root_path) }
        end
      end

      context 'Without email confirmation' do
        let(:user_without_email_confirmation) { FactoryGirl.create(:user_without_email_confirmation) }
        let(:user) { FactoryGirl.create(:user) }

        before { sign_in user_without_email_confirmation }
        it { expect(current_path).to eq(sessions_path) }
        it { should have_selector('div.alert.alert-error') }

        context "Other users can't see users without email confirmation" do
          before do
            sign_in user
            visit users_path
          end

          it { should_not have_content(user_without_email_confirmation.name)}
        end
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "it should not be displyed" do
        it { should_not have_link('Profile',     href: user_path(user)) }
        it { should_not have_link('Settings',    href: edit_user_path(user)) }
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          # fill_signin_form( user )
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "after signing out and signing in again" do
            before do
              sign_out
              sign_in user
            end
            it "should render the users page" do
              expect(page).to have_title(user.name)
            end
          end
        end

        describe "in the Relationships controller" do
          describe "submitting to the create action" do
            before { post relationships_path }
            specify { expect(response).to redirect_to(signin_path) }
          end

          describe "submitting to the destroy action" do
            before { delete relationship_path(1) }
            specify { expect(response).to redirect_to(signin_path) }
          end
        end

      end

      describe "in the Users controller" do

        describe "visiting the index page" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end

      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as admin" do
      let(:user) { FactoryGirl.create(:admin) }
      before { sign_in( user, no_capybara: true ) }

      describe "not allow to delete admin" do
        before { delete user_path(user) }
        it { expect{ user.reload }.not_to raise_error }
      end
    end
  end
end
