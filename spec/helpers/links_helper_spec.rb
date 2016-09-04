require 'spec_helper'

describe LinksHelper, type: :helper do
  describe "youtube_video" do
    it "returns the html code for the video" do
      expect(helper.youtube_video('ZnehCBoYLbc')).to eq '<iframe src="http://www.youtube.com/embed/ZnehCBoYLbc" frameborder="0" allowfullscreen></iframe>'
    end
  end

  describe "extract_youtube_id_from_url" do
    it "extracts the youtube video id from a youtube video url" do
      url = "http://www.youtube.com/watch?v=ZnehCBoYLbc"
      expect(helper.extract_youtube_id_from_url(url)).to eq('ZnehCBoYLbc')
    end

    it "extracts the youtube video id from a youtube video url with more params and https" do
      url = "https://www.youtube.com/watch?v=_O7iUiftbKU&feature=relmfu"
      expect(helper.extract_youtube_id_from_url(url)).to eq('_O7iUiftbKU')
    end

    it "extracts the youtube video id from a short youtube video url" do
      url = "http://youtu.be/_O7iUiftbKU"
      expect(helper.extract_youtube_id_from_url(url)).to eq('_O7iUiftbKU')
    end
  end

  describe "detect_youtube_url" do
    it "detects and returns a youtube video url from a string" do
      line = "This is a really kewl vid: http://www.youtube.com/watch?v=ZnehCBoYLbc !! lol"
      expect(helper.detect_youtube_url(line)).to eq("http://www.youtube.com/watch?v=ZnehCBoYLbc")
    end

    it "detects and returns a https youtube video url from a string" do
      line = "This i a really kewl vid: https://www.youtube.com/watch?v=ZnehCBoYLbc !! lol"
      expect(helper.detect_youtube_url(line)).to eq("https://www.youtube.com/watch?v=ZnehCBoYLbc")
    end

    it "detects and returns a short youtube video url from a string" do
      line = "This i a really kewl vid: http://youtu.be/ZnehCBoYLbc !! lol"
      expect(helper.detect_youtube_url(line)).to eq("http://youtu.be/ZnehCBoYLbc")
    end

    it "returns false when there is no youtube video url" do
      line = "No video here, but a link http://www.yousuck.com/dontwatch?v=ZnehCBoYLbc !!"
      expect(helper.detect_youtube_url(line)).to be_nil
    end
  end
end
