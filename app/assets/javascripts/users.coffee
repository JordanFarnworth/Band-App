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

$('.users.show').ready ->
  $('#update-user-data-btn').on 'click', ->
    user = new User()
    $('#edit-user-data-form').formValidation 'validate'
    if $('#edit-user-data-form').data('formValidation').isValid()
      user.updateUserInfo()

  $('#update-user-password').on 'click', ->
    user = new User()
    if $('#change-password-modal-form').data('formValidation').isValid()
      user.updateUserPassword()
