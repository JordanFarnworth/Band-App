# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.parties.show').ready ->
  getPartyInfo()

$('.users.show').ready ->
  $('#create-party-button').on 'click', ->
    validateParsely($('#party-general-info-form').parsley().validate(), "party-general-info-tab")
    validateParsely($('#party-social-media-form').parsley().validate(), "party-social-media-tab")
    validateParsely($('#party-contact-info-form').parsley().validate(), "party-contact-info-tab")
    # If the form is valid, will proceed with submission.
    if $('#party-general-info-form').parsley().isValid() && $('#party-social-media-form').parsley().isValid() && $('#party-contact-info-form').parsley().isValid()
     createParty()

getPartyInfo = ->
  party = window.location.pathname.match(/\/parties\/(\d+)/)[1]
  $.ajax "/api/v1/parties/#{party}",
    type: 'get'
    dataType: 'json'
    success: (data) ->
      populatePartyPage(data)

populatePartyPage = (data) ->
  compileHbsTemplate('')


createParty = ->
  $.ajax '/api/v1/parties',
    type: 'post'
    dataType: 'json'
    data:
      party:
        name: $('#party-name').val()
        description: $('#party-description').val()
        social_media:
          facebook: $('#party-facebook').val()
          twitter: $('#party-twitter').val()
          instagram: $('#party-instagram').val()
        data:
          email: $('#party-email').val()
          address: $('#party-mailing-address').val()
          phone_number: $('#party-phone-number').val()
          owner: $('#party-owner').val()
    success: (data) ->
      $('#myModal').modal('hide')
      bootbox.alert "<a href="/parties/#{data.id}">#{data.name}</a> was created.", (result) ->
        console.log result


validateParsely = (pass, id) ->
  if pass == true
    $('#' + id).css('color', 'white')
  else
    $('#' + id).css('color', 'red')

compileHbsTemplate = (hbsid, elid, data) ->
  template = Handlebars.compile($("script#" + hbsid).html())
  temp = $(template(data))
  $("#" + elid).html(temp)
