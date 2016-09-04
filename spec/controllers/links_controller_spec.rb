require 'spec_helper'

describe LinksController, type: :controller do
  describe 'GET :index' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby'
    end

    it { is_expected.to respond_with(:success) }
    it do
      expect(assigns(:network)).to eq('freenode')
    end
    it do
      expect(assigns(:channel)).to eq('ruby')
    end
    it do
      expect(assigns(:links)).to_not be_nil
    end
  end

  describe 'GET :index with search param' do
    before do
      expect(Link).to receive(:search_text).with('term').and_return(Link)
      get :index, :network => 'freenode', :channel => 'ruby', :search => 'term'
    end

    it { is_expected.to respond_with(:success) }
    it do
      expect(assigns(:network)).to eq('freenode')
    end
    it do
      expect(assigns(:channel)).to eq('ruby')
    end
    it do
      expect(assigns(:links)).to_not be_nil
    end
  end

  describe 'GET :index .rss' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby', :format => :rss
    end

    it { is_expected.to respond_with(:success) }
    it do
      expect(assigns(:network)).to eq('freenode')
    end
    it do
      expect(assigns(:channel)).to eq('ruby')
    end
    it do
      expect(assigns(:links)).to_not be_nil
    end
  end

  describe 'POST :create' do
    before do
      post :create, :network => 'freenode', :channel => 'ruby',
           :link => { :sender => 'nick', :line => 'Love this : http://ruby.fr' }
    end

    it { is_expected.to respond_with(:success) }
    it do
      expect(assigns(:link)).to be_valid
      expect(assigns(:link)).to be_persisted
    end
  end
end
