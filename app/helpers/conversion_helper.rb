module ConversionHelper
  YOUTUBE_PATTERN = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
  FACEBOOK_PATTERN = /^(https?:\/\/){0,1}(www\.){0,1}facebook\.com/
  PHONE_NUMBER_PATTERN = /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/
  def self.convert_youtube_link(link)
    yt_id = link.match(YOUTUBE_PATTERN)
    "https://www.youtube.com/embed/#{yt_id[2]}" if yt_id
  end
end
