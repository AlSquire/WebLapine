require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the LinksHelper. For example:
#
# describe LinksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe LinksHelper do
  describe "youtube_video" do
    it "return an iframe of the video" do
      helper.youtube_video('ZnehCBoYLbc').should == '<object width="425" height="349"><param name="movie" value="http://www.youtube-nocookie.com/v/ZnehCBoYLbc?version=3&amp;hl=fr_FR&amp;rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube-nocookie.com/v/ZnehCBoYLbc?version=3&amp;hl=fr_FR&amp;rel=0" type="application/x-shockwave-flash" width="425" height="349" allowscriptaccess="always" allowfullscreen="true"></embed></object>'
    end
  end

  describe "extract_youtube_id_from_url" do
    it "extract the youtube video id from a youtube video url" do
      url = "http://www.youtube.com/watch?v=ZnehCBoYLbc"
      helper.extract_youtube_id_from_url(url).should == 'ZnehCBoYLbc'
    end

    it "extract the youtube video id from a youtube video url with more params" do
      url = "http://www.youtube.com/watch?v=_O7iUiftbKU&feature=relmfu"
      helper.extract_youtube_id_from_url(url).should == '_O7iUiftbKU'
    end
  end

  describe "detect_youtube_url" do
    it "detect and return a youtube video url from a string" do
      line = "This i a really kewl vid: http://www.youtube.com/watch?v=ZnehCBoYLbc !! lol"
      helper.detect_youtube_url(line).should == "http://www.youtube.com/watch?v=ZnehCBoYLbc"
    end

    it "return false when there is no youtube video url" do
      line = "No video here, but a link http://www.yousuck.com/dontwatch?v=ZnehCBoYLbc !!"
      helper.detect_youtube_url(line).should be_nil
    end
  end
end
