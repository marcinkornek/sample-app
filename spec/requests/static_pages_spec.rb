require 'spec_helper'

describe "Static pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  describe "Home page" do
    before {visit about_path}

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
    it { should_not have_title("Home") }
  end

  describe "Home page" do
    before {visit about_path}

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe "Help page" do
    before {visit help_path}

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "Contact page" do
    before {visit contact_path}

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end
