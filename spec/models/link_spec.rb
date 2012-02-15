# coding: utf-8
require 'spec_helper'

describe Link do
  it { should validate_presence_of(:network) }
  it { should validate_presence_of(:channel) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:line) }

  it { described_class.should respond_to(:search) }
  describe ".search" do
    before do
      ["Lorem ipsum http://something.com", "A la claire http://something.com fontaine", "http://something.com Claire habite à Lorient"].each do |line|
        Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { Link.search('claire').count.should == 2 }
    it { Link.search('lor').count.should == 2 }
    it { Link.search('  L  ').count.should == 3 }
    it { Link.search('kamehameha').count.should == 0 }
  end

  describe "#create with an image uri" do
    before do
      line = "It's a great photo http://something.fr/cat.png xD"
      Link.should_receive(:request_resource_mirroring)
          .with("http://something.fr/cat.png")
          .and_return('http://files.catstorage.com/12345.png')
      @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end

    it { @link.uri.should == "http://something.fr/cat.png" }
    it { @link.should be_image }
    it { @link.mirror_uri.should == "http://files.catstorage.com/12345.png" }
  end
end
