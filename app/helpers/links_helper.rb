module LinksHelper
  # Sample youtube urls:
  #   http://www.youtube.com/watch?v=ZnehCBoYLbc
  #   http://www.youtube.com/watch?v=_O7iUiftbKU&feature=relmfu

  def youtube_video(video_id)
    embed_code = '<object width="425" height="349"><param name="movie" value="http://www.youtube-nocookie.com/v/' + h(video_id) + '?version=3&amp;hl=fr_FR&amp;rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube-nocookie.com/v/ZnehCBoYLbc?version=3&amp;hl=fr_FR&amp;rel=0" type="application/x-shockwave-flash" width="425" height="349" allowscriptaccess="always" allowfullscreen="true"></embed></object>'
    embed_code.html_safe
  end

  def extract_youtube_id_from_url(url)
    CGI.parse(URI.parse(url).query)["v"].first
  end

  def detect_youtube_url(line)
    regexp = /http:\/\/www.youtube.com\/watch\?[^\s]*/
    match = line.match(regexp)
    match[0] if match
  end
end
