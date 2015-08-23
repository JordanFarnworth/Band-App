# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class User
  constructor: ->
    @user = window.location.pathname.match(/\/users\/(\d+)/)[1]

  validateForm: (pass, id) =>
    if pass == true
      $('#' + id).css('color', 'white')
    else
      $('#' + id).css('color', 'red')

  compileHbsTemplate: (hbsid, elid, data) =>
    template = Handlebars.compile($("script#" + hbsid).html())
    temp = $(template(data))
    $("#" + elid).html(temp)

  appendHbsTemplate: (hbsid, elid, data) =>
    template = Handlebars.compile($("script#" + hbsid).html())
    temp = $(template(data))
    $("#" + elid).append(temp)

  #get bands and parties
    #calling the user data through the getUserBands function
  getUserBands: =>
    $.ajax "/api/v1/users/#{@user}?include[]=bands",
      type: 'get'
      dataType: 'json'
      success: (data) ->
        new User().compileHbsTemplate('user-data', 'band-data-div', data)
        new User().compileHbsTemplate('user-title', 'user-title-div', data)
        new User().populateEditModal(data)
        $('#user-bands-list').empty()
        $.each data['bands'], (i) ->
          new User().appendHbsTemplate('user-bands', 'user-bands-list', this)

  getUserParties: =>
    $.ajax "/api/v1/users/#{@user}?include[]=parties",
      type: 'get'
      dataType: 'json'
      success: (data) ->
        $('#user-parties-list').empty()
        $.each data.parties, (i) ->
          new User().appendHbsTemplate('user-parties', 'user-parties-list', this)
  #end get calls

  populateEditModal: (data) =>
    $('#username-edit').val("#{data.username}")
    $('#user-display-name').val("#{data.display_name}")
    $('#user-email-edit').val("#{data.email}")

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
            genre: $('#genre').val()
            phone_number: $('#band-phone-number').val()
            youtube_link: $('#band-youtube').val()
      success: (data) ->
        new User().clearBandModal()
        $('#createBandModal').modal('hide')
        bootbox.alert('Band Created!', null)
        new User().getUserBands()

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
        new User().clearPartyModal()
        $('#myModal').modal('hide')
        bootbox.alert('Party Created!', null)
        new User().getUserParties()
  #end create

  #update user info/passwords
  updateUserInfo: =>
    $.ajax "/api/v1/users/#{@user}",
      type: 'put'
      dataType: 'json'
      data:
        user:
          username: $('#username-edit').val()
          display_name: $('#user-display-name').val()
          email: $('#user-email-edit').val()
      success: (data) ->
        $('#userEditModal').modal('hide')
        $('#edit-user-data-form').data('formValidation').resetForm()
        new User().getUserBands()
        bootbox.alert('User Updated!', null)

  updateUserPassword: =>
    $.ajax "/api/v1/users/#{@user}",
      type: 'put'
      dataType: 'json'
      data:
        user:
          password: $('#new-password').val()
      success: (data) ->
        $('#changePasswordModal').modal('hide')
        new User().clearChangePasswordModal()
        bootbox.alert('Password Updated', null)
  #end updates

  clearChangePasswordModal: =>
    $('#old-password').val('')
    $('#new-password').val('')
    $('#confirm-new-password').val('')
    $('#change-password-modal-form').data('formValidation').resetForm()


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
  $('#edit-user-data-form').formValidation
    excluded: ':disabled'
  $('#change-password-modal-form').formValidation
    excluded: ':disabled'
  new User().getUserBands()
  new User().getUserParties()


  $('#create-band').on 'click', ->
    user = new User()
    $('#band-general-info-form').formValidation('validate')
    $('#band-social-media-form').formValidation('validate')
    $('#band-contact-info-form').formValidation('validate')
    $('#band-audio-sample-form').formValidation('validate')
    user.validateForm($('#band-general-info-form').data('formValidation').isValid(), "band-general-info-tab")
    user.validateForm($('#band-social-media-form').data('formValidation').isValid(), "band-social-media-tab")
    user.validateForm($('#band-contact-info-form').data('formValidation').isValid(), "band-contact-info-tab")
    user.validateForm($('#band-audio-sample-form').data('formValidation').isValid(), "band-audio-sample-tab")
    # If the form is valid, will proceed with submission.
    if $('#band-general-info-form').data('formValidation').isValid() && $('#band-social-media-form').data('formValidation').isValid() && $('#band-contact-info-form').data('formValidation').isValid() && $('#band-audio-sample-form').data('formValidation').isValid()
      user.createBand()

  $('#create-party').on 'click', ->
    user = new User()
    $('#party-general-info-form').formValidation('validate')
    $('#party-social-media-form').formValidation('validate')
    $('#party-contact-info-form').formValidation('validate')
    user.validateForm($('#party-general-info-form').data('formValidation').isValid(), "party-general-info-tab")
    user.validateForm($('#party-social-media-form').data('formValidation').isValid(), "party-social-media-tab")
    user.validateForm($('#party-contact-info-form').data('formValidation').isValid(), "party-contact-info-tab")
    # If the form is valid, will proceed with submission.
    if $('#party-general-info-form').data('formValidation').isValid() && $('#party-social-media-form').data('formValidation').isValid() && $('#party-contact-info-form').data('formValidation').isValid()
      user.createParty()

  $('#update-user-data-btn').on 'click', ->
    user = new User()
    $('#edit-user-data-form').formValidation 'validate'
    if $('#edit-user-data-form').data('formValidation').isValid()
      user.updateUserInfo()

  $('#update-user-password').on 'click', ->
    user = new User()
    if $('#change-password-modal-form').data('formValidation').isValid()
      user.updateUserPassword()
