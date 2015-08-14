# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.bands.show').ready ->
  getBandData()
  $('#sticky-buttons').sticky topSpacing: 50

$('.users.show').ready ->
  $('#create-band').on 'click', ->
    validateParsely($('#band-general-info-form').parsley().validate(), "band-general-info-tab")
    validateParsely($('#band-social-media-form').parsley().validate(), "band-social-media-tab")
    validateParsely($('#band-contact-info-form').parsley().validate(), "band-contact-info-tab")
    validateParsely($('#band-audio-sample-form').parsley().validate(), "band-audio-sample-tab")
    # If the form is valid, will proceed with submission.
    if $('#band-general-info-form').parsley().isValid()
      if $('#band-social-media-form').parsley().isValid()
        if $('#band-contact-info-form').parsley().isValid()
          if $('#band-audio-sample-form').parsley().isValid()
            createBand()


  $('#clear-band-modal').on 'click', ->
    bootbox.confirm 'Are you sure you want to clear ALL fields?', (result) ->
      clearBandModal()

validateParsely = (pass, id) ->
  debugger
  if pass == true
    $('#' + id).css('color', 'white')
  else
    $('#' + id).css('color', 'red')


getBandData = ->
  band = window.location.pathname.match(/\/bands\/(\d+)/)[1]
  $.ajax "/api/v1/bands/#{band}",
    type: 'get'
    dataType: 'json'
    success: (data) ->
      console.log data
      populatePage(data)
      
createBand = ->
  $.ajax '/api/v1/bands',
    type: 'post'
    dataType: 'json'
    data:
      band:
        name: $('#band-name').val()
        description: $('#band-description').val()
        social_media:
          twitter: $('#band-twitter').val()
          facebook: $('#band-facebook').val()
          instagram: $('#band-instagram').val()
        data:
          email: $('#band-email').val()
          genre: $('#genre').val()
          address: $('#band-mailing-address').val()
          phone_number: $('#band-phone-number').val()
          youtube_link: $('#band-youtube').val()
    success: (data) ->
      clearBandModal()
      $('#createBandModal').modal('hide')

clearBandModal = ->
  $('#bandName').val("")
  $('#bandDescription').val("")
  $('#twitter').val("")
  $('#facebook').val("")
  $('#instagram').val("")
  $('#email').val("")
  $('#genre').val("")
  $('#mailingAddress').val("")
  $('#phoneNumber').val("")
  $('#youtube').val("")
  $('#createBandForm').parsley().reset()

populatePage = (band) ->
  compileHbsTemplate("band-social-media", "social-media", band.social_media)
  compileHbsTemplate("band-contact-data", "contact-info", band.data)
  compileHbsTemplate("band-description", "description", band)
  compileHbsTemplate("band-name", "band-name", band)
  compileHbsTemplate("band-youtube-video", "youtube-video", band.data)
  compileHbsTemplate("band-music-sample", "band-music-sample-show", band.data)
  compileHbsTemplate("band-reviews", "reviews", band)


compileHbsTemplate = (hbsid, elid, data) ->
  template = Handlebars.compile($("script#" + hbsid).html())
  temp = $(template(data))
  $("#" + elid).html(temp)
