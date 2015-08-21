# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.users.show').ready ->
  $('#band-general-info-form').formValidation
    excluded: ':disabled'
  $('#band-social-media-form').formValidation
    excluded: ':disabled'
  $('#band-contact-info-form').formValidation
    excluded: ':disabled'
  $('#band-audio-sample-form').formValidation
    excluded: ':disabled'
  $('#party-general-info-form').formValidation
      excluded: ':disabled'
  $('#party-social-media-form').formValidation
      excluded: ':disabled'
  $('#party-contact-info-form').formValidation
    excluded: ':disabled'

  $('#create-band').on 'click', ->
    $('#band-general-info-form').formValidation('validate')
    $('#band-social-media-form').formValidation('validate')
    $('#band-contact-info-form').formValidation('validate')
    $('#band-audio-sample-form').formValidation('validate')
    validateForm($('#band-general-info-form').data('formValidation').isValid(), "band-general-info-tab")
    validateForm($('#band-social-media-form').data('formValidation').isValid(), "band-social-media-tab")
    validateForm($('#band-contact-info-form').data('formValidation').isValid(), "band-contact-info-tab")
    validateForm($('#band-audio-sample-form').data('formValidation').isValid(), "band-audio-sample-tab")
    # If the form is valid, will proceed with submission.
    if $('#band-general-info-form').data('formValidation').isValid() && $('#band-social-media-form').data('formValidation').isValid() && $('#band-contact-info-form').data('formValidation').isValid() && $('#band-audio-sample-form').data('formValidation').isValid()
      createBand()

  $('#create-party').on 'click', ->
    $('#party-general-info-form').formValidation('validate')
    $('#party-social-media-form').formValidation('validate')
    $('#party-contact-info-form').formValidation('validate')
    validateForm($('#party-general-info-form').data('formValidation').isValid(), "party-general-info-tab")
    validateForm($('#party-social-media-form').data('formValidation').isValid(), "party-social-media-tab")
    validateForm($('#party-contact-info-form').data('formValidation').isValid(), "party-contact-info-tab")
    # If the form is valid, will proceed with submission.
    if $('#party-general-info-form').data('formValidation').isValid() && $('#party-social-media-form').data('formValidation').isValid() && $('#party-contact-info-form').data('formValidation').isValid()
      createParty()

validateForm = (pass, id) ->
  if pass == true
    $('#' + id).css('color', 'white')
  else
    $('#' + id).css('color', 'red')


createBand = ->
  $.ajax '/api/v1/bands',
    type: 'post'
    dataType: 'json'
    data:
      band:
        name: $('#band-name').val()
        description: $('#band-description').val()
        address: $('#band-mailing-address').val()
        social_media:
          twitter: $('#band-twitter').val()
          facebook: $('#band-facebook').val()
          instagram: $('#band-instagram').val()
        data:
          email: $('#band-email').val()
          genre: $('#genre').val()
          phone_number: $('#band-phone-number').val()
          youtube_link: $('#band-youtube').val()
    success: (data) ->
      clearBandModal()
      $('#createBandModal').modal('hide')
      bootbox.alert('Band Created!', null)

createParty = ->
  $.ajax '/api/v1/parties',
    type: 'post'
    dataType: 'json'
    data:
      party:
        name: $('#party-name').val()
        description: $('#party-description').val()
        address: $('#party-mailing-address').val()
        social_media:
          facebook: $('#party-facebook').val()
          twitter: $('#party-twitter').val()
          instagram: $('#party-instagram').val()
        data:
          email: $('#party-email').val()
          phone_number: $('#party-phone-number').val()
          owner: $('#party-owner').val()
    success: (data) ->
      $('#myModal').modal('hide')
      clearPartyModal()
      bootbox.alert('Party Created!', null)

clearBandModal = ->
  $('#band-name').val('')
  $('#band-description').val('')
  $('#band-twitter').val('')
  $('#band-facebook').val('')
  $('#band-instagram').val('')
  $('#band-email').val('')
  $('#genre').val('')
  $('#band-mailing-address').val('')
  $('#band-phone-number').val('')
  $('#band-youtube').val('')
  $('#band-general-info-form').data('formValidation').resetForm()
  $('#band-social-media-form').data('formValidation').resetForm()
  $('#band-contact-info-form').data('formValidation').resetForm()
  $('#band-audio-sample-form').data('formValidation').resetForm()


clearPartyModal = ->
  $('#party-name').val('')
  $('#party-description').val('')
  $('#party-mailing-address').val('')
  $('#party-facebook').val('')
  $('#party-twitter').val('')
  $('#party-instagram').val('')
  $('#party-email').val('')
  $('#party-phone-number').val('')
  $('#party-owner').val('')
  $('#party-general-info-form').data('formValidation').resetForm()
  $('#party-social-media-form').data('formValidation').resetForm()
  $('#party-contact-info-form').data('formValidation').resetForm()
