# coding: utf-8
require 'spec_helper'

describe Link do
  it { is_expected.to validate_presence_of(:network) }
  it { is_expected.to validate_presence_of(:channel) }
  it { is_expected.to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:line) }

  it { expect(described_class).to respond_to(:search_text) }
  describe ".search_text" do
    before do
      ["Lorem ipsum http://something.com", "A la claire http://something.com fontaine", "http://something.com Claire habite à Lorient"].each do |line|
        Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { expect(Link.search_text('claire').count).to eq(2) }
    it { expect(Link.search_text('lor').count).to eq(2) }
    it { expect(Link.search_text('  L  ').count).to eq(3) }
    it { expect(Link.search_text('kamehameha').count).to eq(0) }
  end

  describe "#create with an image uri" do
    before do
      line = "It's a great photo http://something.fr/cat.png xD"
      expect(Link).to receive(:request_resource_mirroring).
           with("http://something.fr/cat.png").
           and_return('http://files.catstorage.com/12345.png')
      @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end

    it { expect(@link.uri).to  eq("http://something.fr/cat.png") }
    it { expect(@link).to be_image }
    it { expect(@link.mirror_uri).to eq("http://files.catstorage.com/12345.png") }
  end

  describe "#create with an image uri with query params" do
    before do
      line = "It's a great photo http://something.fr/cat.png?a=b&c=d xD"
      expect(Link).to receive(:request_resource_mirroring).
           with("http://something.fr/cat.png?a=b&c=d").
           and_return('http://files.catstorage.com/12345.png')
      @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end

    it { expect(@link.uri).to eq("http://something.fr/cat.png?a=b&c=d") }
    it { expect(@link).to be_image }
    it { expect(@link.mirror_uri).to eq("http://files.catstorage.com/12345.png") }
  end

  describe "#create with an imgur uri" do
    before do
      line = "When you see it http://imgur.com/r/funny/Mg63N you'll..."
      expect(Link).to receive(:request_resource_mirroring).
          with("http://i.imgur.com/Mg63N.jpg").
          and_return('http://files.catstorage.com/12345.png')
      VCR.use_cassette('imgur') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { expect(@link.uri).to eq("http://imgur.com/r/funny/Mg63N") }
    it { expect(@link).to be_imgur }
    it { expect(@link.imgur_image_uri).to eq("http://i.imgur.com/Mg63N.jpg") }
    it { expect(@link.mirror_uri).to eq("http://files.catstorage.com/12345.png") }
  end

  describe "#create with an imgur uri which don't contain an image" do
    before do
      line = "It's http://imgur.com/faq only"
      expect(Link).to_not receive(:request_resource_mirroring)
      VCR.use_cassette('imgur_faq') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { expect(@link.uri).to eq("http://imgur.com/faq") }
    it { expect(@link).to be_imgur }
    it { expect(@link.imgur_image_uri).to be_nil }
    it { expect(@link.mirror_uri).to be_nil }
  end

  describe "#create with an 9gag uri" do
    before do
      line = "When you see it http://9gag.com/gag/4162289 you'll..."
      expect(Link).to receive(:request_resource_mirroring).
          with("http://d24w6bsrhbeh9d.cloudfront.net/photo/4162289_700b.jpg").
          and_return('http://files.catstorage.com/12345.png')
      VCR.use_cassette('9gag') do
        @link = Link.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
      end
    end

    it { expect(@link.uri).to eq("http://9gag.com/gag/4162289") }
    it { expect(@link).to be_ninegag }
    it { expect(@link.ninegag_image_uri).to eq("http://d24w6bsrhbeh9d.cloudfront.net/photo/4162289_700b.jpg") }
    it { expect(@link.mirror_uri).to eq("http://files.catstorage.com/12345.png") }
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
          it { expect(@link).to_not be_nws }
          it { expect(@link).to_not be_nms }
          it { expect(@link).to_not be_spoiler }
        end
      end

    end

    describe "#nws?" do
      lines = [
        "When you see it http://9gag.com/gag/4162289 you'll... NWS",
        "Nsfw!!! When you see it http://9gag.com/gag/4162289 you'll...",
        "http://9gag.com/gag/4162289 (nws)"
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { expect(@link).to be_nws }
          it { expect(@link).to_not be_nms }
        end
      end
    end

    describe "#nms?" do
      lines = [
        "When you see it http://9gag.com/gag/4162289 you'll... NMS!",
        "Nsfm!!! When you see it http://9gag.com/gag/4162289 you'll...",
        "http://9gag.com/gag/4162289 (nms)"
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { expect(@link).to be_nms }
          it { expect(@link).to be_nws }
        end
      end
    end

    describe "#spoiler?" do
      lines = [
        "http://9gag.com/gag/4162289 hey spoil!",
        "Spoiler: When you see it http://9gag.com/gag/4162289 you'll...",
        "Dem spoilers http://9gag.com/gag/4162289",
        "http://9gag.com/gag/4162289 (spoilers)"
      ]

      lines.each do |line|
        describe "#{line}" do
          before { @link = Link.new(:line => line) }
          it { expect(@link).to be_spoiler }
        end
      end
    end
  end
end
