module LinksHelper
  # Sample youtube urls:
  #   http://www.youtube.com/watch?v=ZnehCBoYLbc
  #   https://www.youtube.com/watch?v=_O7iUiftbKU&feature=relmfu
  #   http://youtu.be/ZzOPK1W6DqI

  def youtube_video(video_id)
    embed_code = '<iframe src="http://www.youtube.com/embed/' + h(video_id) + '" frameborder="0" allowfullscreen></iframe>'
    embed_code.html_safe
  end

  def extract_youtube_id_from_url(url)
    if url.match(regexpes[:classic])
      CGI.parse(URI.parse(url).query)["v"].first
    elsif url.match(regexpes[:short])
      url.split('/').last
    end
  end

  def detect_youtube_url(line)
    match = line.match(regexpes[:classic])
    match ||= line.match(regexpes[:short])
    match[0] if match
  end

  def regexpes
    @regexpes ||= {
      classic: /http[s]?:\/\/www.youtube.com\/watch\?[^\s]*/i,
      short: /http[s]?:\/\/youtu.be\/[^\s]*/i
    }
  end
end
