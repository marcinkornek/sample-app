require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

    describe "should count microposts" do
      before do
        fill_in 'micropost_content', with: "Lorem ipsum"
        click_button "Post"
      end
      it { should have_content("1 micropost") }
    end

    describe 'private message' do
      describe 'with valid information' do
        before do
          @user = FactoryGirl.create(:user)
          @mentioned_user = FactoryGirl.create(:user, username: 'username_mars')
          @other_user = FactoryGirl.create(:user)
          sign_in @user
          visit root_path
          fill_in 'micropost_content', with: "@username_mars asadsad"
          click_button "Post"
        end

        context 'in User home page' do

          it { should have_content("1 micropost") }
          it { should have_content("0 received private micropost") }
          it { should have_content("@username_mars asadsad") }
        end

        context 'in Mentioned user home page' do
          before do
            sign_out
            sign_in @mentioned_user, no_capybara: true
            visit root_path
          end

          it { should have_content("0 microposts") }
          it { should have_content("1 received private micropost")}
          it { should have_content("@username_mars asadsad") }
        end

         context 'in Other user home page' do
          before do
            sign_out
            sign_in @other_user, no_capybara: true
            visit root_path
          end

          it { should have_content("0 microposts") }
          it { should have_content("0 received private microposts")}
          it { should_not have_content("@username_mars asadsad") }
        end
      end



      describe 'with invalid information' do
        before do
          @mentioned_user = FactoryGirl.create(:user, username: 'username_mars')
          @user = FactoryGirl.create(:user)
          visit root_path
          fill_in 'micropost_content', with: "@invalid_username asadsad"
          click_button "Post"
        end

        it { should have_selector('div.alert.alert-error') } #it should return error message
        # it {expect { click_button 'Post' }.to_not change(Micropost, :count)}
      end
    end

  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "pagination" do

    before(:each) do
      30.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end

    it { should have_selector('div.pagination') }

    it "should list each micropost" do
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_selector('li', text: micropost.content)
      end
    end

    describe "should count microposts" do
      it { should have_content("30 microposts") }
    end
  end

  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user) }
    before { sign_in wrong_user }

    describe "create microposts for wrong user" do
      before do
        FactoryGirl.create(:micropost, user: wrong_user)
        sign_out
        sign_in user
      end

      describe "should not see wrong user 'delete' links" do
        before { visit user_path(wrong_user) }
        it { should_not have_content('delete') }

      end
    end
  end

end


