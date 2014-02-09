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
      Link.should_receive(:request_resource_mirroring).
           with("http://something.fr/cat.png").
           and_return('http://files.catstorage.com/12345.png')
      @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end

    it { @link.uri.should == "http://something.fr/cat.png" }
    it { @link.should be_image }
    it { @link.mirror_uri.should == "http://files.catstorage.com/12345.png" }
  end

  describe "#create with an imgur uri" do
    before do
      line = "When you see it http://imgur.com/r/funny/Mg63N you'll..."
      Link.should_receive(:request_resource_mirroring).
          with("http://i.imgur.com/Mg63N.jpg").
          and_return('http://files.catstorage.com/12345.png')
      VCR.use_cassette('imgur') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { @link.uri.should == "http://imgur.com/r/funny/Mg63N" }
    it { @link.should be_imgur }
    it { @link.imgur_image_uri.should == "http://i.imgur.com/Mg63N.jpg" }
    it { @link.mirror_uri.should == "http://files.catstorage.com/12345.png" }
  end

  describe "#create with an imgur uri which don't contain an image" do
    before do
      line = "It's http://imgur.com/faq only"
      Link.should_not_receive(:request_resource_mirroring)
      VCR.use_cassette('imgur_faq') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { @link.uri.should == "http://imgur.com/faq" }
    it { @link.should be_imgur }
    it { @link.imgur_image_uri.should be_nil }
    it { @link.mirror_uri.should be_nil }
  end

  describe "#create with an 9gag uri" do
    before do
      line = "When you see it http://9gag.com/gag/4162289 you'll..."
      Link.should_receive(:request_resource_mirroring).
          with("http://d24w6bsrhbeh9d.cloudfront.net/photo/4162289_700b.jpg").
          and_return('http://files.catstorage.com/12345.png')
      VCR.use_cassette('9gag') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { @link.uri.should == "http://9gag.com/gag/4162289" }
    it { @link.should be_ninegag }
    it { @link.ninegag_image_uri.should == "http://d24w6bsrhbeh9d.cloudfront.net/photo/4162289_700b.jpg" }
    it { @link.mirror_uri.should == "http://files.catstorage.com/12345.png" }
  end

  describe "warning tags" do
    describe "safe" do
      lines = [
        "When you see it http://9gag.com/gag/4162289 you'll... no it's safe",
        "It's ok. When you see it http://9gag.com/gag/4162289 you'll...",
         "An url with a tag http://youtube.com/abNMScNWS ho it is?"
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { @link.should_not be_nws }
          it { @link.should_not be_nms }
        end
      end

    end

    describe "#nws?" do
      lines = [
        "When you see it http://9gag.com/gag/4162289 you'll... NWS",
        "Nsfw!!! When you see it http://9gag.com/gag/4162289 you'll..."
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { @link.should be_nws }
          it { @link.should_not be_nms }
        end
      end
    end

    describe "#nms?" do
      lines = [
        "When you see it http://9gag.com/gag/4162289 you'll... NMS",
        "Nsfm!!! When you see it http://9gag.com/gag/4162289 you'll..."
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { @link.should be_nms }
          it { @link.should be_nws }
        end
      end
    end
  end
end
