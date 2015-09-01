# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Dashboard
  constructor: ->
    @user = ENV.current_user
    @entity = ENV.current_entity

  validateForm: (pass, id) =>
    if pass == true
      $('#' + id).css('color', 'white')
    else
      $('#' + id).css('color', 'red')

  calendarParams: (events) =>
    {
      events: events
      eventClick: (event) ->
        $('#event-title').text(event.title)
        $('#event-start-date').text(event.start)
        $('#event-end-date').text(event.end)
        $('#event-description').text(event.description)
        $('#event-edit-id').val(event.id)
        $('#event-title-edit').val(event.title)
        $('#event-start-date-edit').val(event.start)
        $('#event-end-date-edit').val(event.end)
        $('#event-description-edit').val(event.description)
        $('#eventModal').modal('show')
    }

  getCalendarData: =>
    $.ajax "/api/v1/entities/#{@entity}/events",
      type: 'get'
      dataType: 'json'
      success: (data) ->
        events = $.map data, (obj, i) ->
          {id: obj['id'], description: obj['description'], title: obj['title'], start: obj['start_time'], end: obj['end_time']}
        $('#calendar').fullCalendar(new Dashboard().calendarParams(events))

  assignEntityType: =>
    $.ajax "/api/v1/users/#{@user}/entity_type",
      type: 'put'
      dataType: 'json'
      data:
        user:
          id: @user
          entity_type: if $('#band-option').is(":checked") == true then 'band' else if $('#party-option').is(":checked") == true then 'party'
      success: (data) ->
        window.location = window.location

  udpdateEvent: =>
    event = $('#event-edit-id').val()
    $.ajax "/api/v1/events/#{event}",
      type: 'put'
      dataType: 'json'
      data:
        event:
          title: $('#event-title-edit').val()
          description: $('#event-description-edit').val()
          start_time: $('#event-start-date-edit').val()
          end_time: $('#event-end-date-edit').val()
      success: (data) ->
        window.location = window.location

  # create band and parties
  createBand: =>
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
            genre: $('#band-genre').val()
            phone_number: $('#band-phone-number').val()
            youtube_link: $('#band-youtube').val()
      success: (data) ->
        new Dashboard().clearBandModal()
        $('#createBandModal').modal('hide')
        window.location = "/bands/#{data.id}"

  createParty: =>
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
        new Dashboard().clearPartyModal()
        $('#createPartyModal').modal('hide')
        window.location = "/parties/#{data.id}"
  #end create
  clearBandModal: =>
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


  clearPartyModal: =>
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

$('.dashboard.calendar').ready ->
  new Dashboard().getCalendarData()
  $('#edit-event-toggle').on 'click', ->
    $('#modal-body-show').toggleClass('hidden')
    $('#event-update').toggleClass('hidden')
    $('#event-delete').toggleClass('hidden')
    $('#modal-body-edit').toggleClass('hidden')
  $('#event-update').on 'click', ->
    new Dashboard().udpdateEvent()


$('.dashboard.index').ready ->
  db = new Dashboard()
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
  $('#edit-user-data-form').formValidation
    excluded: ':disabled'
  $('#change-password-modal-form').formValidation
    excluded: ':disabled'

  $('#band-or-party').on 'click', ->
    db.assignEntityType()

  $('#create-band').on 'click', ->
    db = new Dashboard()
    $('#band-general-info-form').formValidation('validate')
    $('#band-social-media-form').formValidation('validate')
    $('#band-contact-info-form').formValidation('validate')
    $('#band-audio-sample-form').formValidation('validate')
    db.validateForm($('#band-general-info-form').data('formValidation').isValid(), "band-general-info-tab")
    db.validateForm($('#band-social-media-form').data('formValidation').isValid(), "band-social-media-tab")
    db.validateForm($('#band-contact-info-form').data('formValidation').isValid(), "band-contact-info-tab")
    db.validateForm($('#band-audio-sample-form').data('formValidation').isValid(), "band-audio-sample-tab")
    # If the form is valid, will proceed with submission.
    if $('#band-general-info-form').data('formValidation').isValid() && $('#band-social-media-form').data('formValidation').isValid() && $('#band-contact-info-form').data('formValidation').isValid() && $('#band-audio-sample-form').data('formValidation').isValid()
      db.createBand()

  $('#create-party').on 'click', ->
    db = new Dashboard()
    $('#party-general-info-form').formValidation('validate')
    $('#party-social-media-form').formValidation('validate')
    $('#party-contact-info-form').formValidation('validate')
    db.validateForm($('#party-general-info-form').data('formValidation').isValid(), "party-general-info-tab")
    db.validateForm($('#party-social-media-form').data('formValidation').isValid(), "party-social-media-tab")
    db.validateForm($('#party-contact-info-form').data('formValidation').isValid(), "party-contact-info-tab")
    # If the form is valid, will proceed with submission.
    if $('#party-general-info-form').data('formValidation').isValid() && $('#party-social-media-form').data('formValidation').isValid() && $('#party-contact-info-form').data('formValidation').isValid()
      db.createParty()
