# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.bands.show').ready ->
  getBandData()
  $('a[href="#band-contact"]').trigger( "click" )

getBandData = ->
  band = window.location.pathname.match(/\/bands\/(\d+)/)[1]
  $.ajax "/api/v1/bands/#{band}",
    type: 'get'
    dataType: 'json'
    success: (data) ->
      console.log data
      populatePage(data)

populatePage = (band) ->
  compileHbsTemplate("band-social-media", "social-media", band.social_media)
  compileHbsTemplate("band-contact-info", "contact-info", band)
  compileHbsTemplate("band-name", "band-name", band)
  compileHbsTemplate("band-contact-data", "band-contact", band.data)
  compileHbsTemplate("band-youtube-video", "youtube-video", band.data)
  compileHbsTemplate("band-reviews", "reviews", band)


compileHbsTemplate = (hbsid, elid, data) ->
  template = Handlebars.compile($("script#" + hbsid).html())
  temp = $(template(data))
  $("#" + elid).html(temp)
