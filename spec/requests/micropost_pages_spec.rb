require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user){FactoryGirl.create(:user, email: "asdf@asdf.com")}
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count).by(1)
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
  end
  
  describe "micropost destruction" do
    before do 
      FactoryGirl.create(:micropost, user: user)
    end

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
    
    #really not sure what the heck I should do with this one :/
    describe "as incorrect user" do
      before { sign_in wrong_user }
      before { visit root_path}
      
      it "should not have a delete link" do
        page { should_not have_link "delete" }
      end
      
    end
  end
    
end