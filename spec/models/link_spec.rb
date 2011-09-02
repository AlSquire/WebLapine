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
      ["Lorem ipsum", "A la claire fontaine", "Claire habite à Lorient"].each do |line|
        Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { Link.search('claire').count.should == 2 }
    it { Link.search('lor').count.should == 2 }
    it { Link.search('  L  ').count.should == 3 }
    it { Link.search('kamehameha').count.should == 0 }
  end
end
