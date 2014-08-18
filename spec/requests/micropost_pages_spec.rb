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
        visit root_path
      end
      it { should have_content("1 micropost") }
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


