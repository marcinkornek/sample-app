require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before {
    User.all.destroy_all
    @micropost = user.microposts.build(content: "Lorem ipsum")
  }

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
      # before {  }

      context 'user with username' do
        let(:user) { FactoryGirl.create(:user, username: 'marcin12' ) }
        let(:content) { '@marcin12 lolz' }

        it 'returns mentioned user' do
          expect(micropost.extract_mentioned_user).to eq(user)
        end
      end

      # context 'user with 1-word name' do
      #   let(:user) { FactoryGirl.create(:user,name: 'marcin' ) }
      #   let(:content) { '@marcin lolz' }

      #   it 'returns mentioned user' do
      #     expect(micropost.extract_mentioned_user).to eq(user)
      #   end
      # end

    #   context 'user with 2-word name' do
    #     let(:user) { FactoryGirl.create(:user,name: 'asd asdasd' ) }
    #     let(:content) { '@asd-asdasd lolz' }

    #     it 'returns mentioned user' do
    #       expect(micropost.extract_mentioned_user).to eq(user)
    #     end
    #   end

    #   context 'user with 3-word name' do
    #     let(:user) { FactoryGirl.create(:user,name: 'asd asdasd asd') }
    #     let(:content) { '@asd-asdasd-asd lolz' }

    #     it 'handles correctly more than two words' do
    #       expect(micropost.extract_mentioned_user).to eq(user)
    #     end
    #   end
    end

    context 'without mentioned user' do

      context 'with non existant username' do
        let(:user) { FactoryGirl.create(:user,username: 'asdasdasd' ) }
        let(:content) { '@ccc-cccccc lolz' }

        it 'returns nil' do
          expect(micropost.extract_mentioned_user).to eq(nil)
        end
      end

      context 'with email in content' do
        let(:user) { FactoryGirl.create(:user,username: 'asdasdasd' ) }
        let(:content) { 'asassa-aa@ccc.pl lolz' }

        it "doesn't crash with emails" do
          expect(micropost.extract_mentioned_user).to eq(nil)
        end
      end
    end
  end

  describe 'in-reply-to function' do
    before do
      @user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user, username: 'exist_username')
    end

    describe 'micropost with content including user name' do
      before do
        @user.microposts.create(content: "@exist_username random text")
      end

      it 'shoud have user id in in-reply-to column' do
        expect(@user.microposts.first.in_reply_to).to eq(@other_user.id)
      end
    end

     describe 'micropost without content including user name' do
      before do
        @user.microposts.create(content: "@non_exist_username random text")
      end

      it "shoud have 'nil' in in-reply-to column" do
        expect(@user.microposts.first.in_reply_to).to eq(nil)
      end
    end
  end

  describe 'valid_user_in_private_message validation' do
    before do
      @user = FactoryGirl.create(:user)
      @mentioned_user = FactoryGirl.create(:user, username: 'exist_username')
    end

    context 'with content with exist username' do
      subject { Micropost.new(content: "@exist_username random text", user: @user)}
      it { should be_valid }
    end

    context 'with content with text' do
      subject { Micropost.new(content: "random text", user: @user)}
      it { should be_valid }
    end

    context 'with content with non-exist username' do
      subject { Micropost.new(content: "@non_exist_username random text", user: @user)}
      it { should_not be_valid }
    end

  end

end
