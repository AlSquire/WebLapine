require 'spec_helper'

describe LinksController do
  describe 'GET :index' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby'
    end

    it { should respond_with(:success) }
    it do
      should assign_to(:network)
      assigns(:network).should == 'freenode'
    end
    it do
      should assign_to(:channel)
      assigns(:channel).should == 'ruby'
    end
    it do
      should assign_to(:links)
    end
  end

  describe 'POST :create' do
    before do
      post :create, :network => 'freenode', :channel => 'ruby',
           :link => { :sender => 'nick', :line => 'Love this : http://ruby.fr' }
    end

    it { should respond_with(:success) }
    it do
      should assign_to(:link)
      assigns(:link).should be_valid
      assigns(:link).should be_persisted
    end
  end
end
