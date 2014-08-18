require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:in_reply_to) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    too_long_content = "a" * 141
    before { @micropost.content = too_long_content }
    it { should_not be_valid }
  end

  describe "#extract_mentioned_user" do
    let(:micropost) { Micropost.new(content: content) }

    context 'there is mentioned user' do
      before {  }

      context 'user with 1-word name' do
        let(:user) { FactoryGirl.create(:user,name: 'marcin' ) }
        let(:content) { '@marcin lolz' }

        it 'returns mentioned user' do
          expect(micropost.extract_mentioned_user).to eq(user)
        end
      end

      context 'user with 2-word name' do
        let(:user) { FactoryGirl.create(:user,name: 'asd asdasd' ) }
        let(:content) { '@asd-asdasd lolz' }

        it 'returns mentioned user' do
          expect(micropost.extract_mentioned_user).to eq(user)
        end
      end

      context 'user with 3-word name' do
        let(:user) { FactoryGirl.create(:user,name: 'asd asdasd asd') }
        let(:content) { '@asd-asdasd-asd lolz' }

        it 'handles correctly more than two words' do
          expect(micropost.extract_mentioned_user).to eq(user)
        end
      end
    end

    context 'without mentioned user' do

      context 'with non existant user name' do
        let(:user) { FactoryGirl.create(:user,name: 'asd asdasd' ) }
        let(:content) { '@ccc-cccccc lolz' }

        it 'returns nil' do
          expect(micropost.extract_mentioned_user).to eq(nil)
        end
      end

      context 'with email in content' do
        let(:user) { FactoryGirl.create(:user,name: 'asd asdasd' ) }
        let(:content) { 'asassa-aa@ccc.pl lolz' }

        it "doesn't crash with emails" do
          expect(micropost.extract_mentioned_user).to eq(nil)
        end
      end
    end
  end
end
