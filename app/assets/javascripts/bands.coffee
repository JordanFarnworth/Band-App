# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Band
  constructor: ->
    @band = window.location.pathname.match(/\/bands\/(\d+)/)[1]

  getBandData: =>
    $.ajax "/api/v1/bands/#{@band}",
      type: 'get'
      dataType: 'json'
      success: (data) ->
        console.log data
        new Band().populatePage(data)

  populatePage: (band) =>
    @compileHbsTemplate("band-social-media", "social-media", band.social_media)
    @compileHbsTemplate("band-contact-data", "contact-info", band.data)
    @compileHbsTemplate("band-description", "description", band)
    @compileHbsTemplate("band-name", "band-name", band)
    @compileHbsTemplate("band-youtube-video", "youtube-video", band.data)
    @compileHbsTemplate("band-music-sample", "band-music-sample-show", band.data)
    @compileHbsTemplate("band-reviews", "reviews", band)

  compileHbsTemplate: (hbsid, elid, data) =>
    template = Handlebars.compile($("script#" + hbsid).html())
    temp = $(template(data))
    $("#" + elid).html(temp)

$('.bands.show').ready ->
  new Band().getBandData()
  $('#sticky-buttons').sticky topSpacing: 50
