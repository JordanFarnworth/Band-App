# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.login.landing').ready ->
  #TODO fix this frd
  $('#login').on 'click', ->
    setTimeout (->
      $('.modal-backdrop.fade.in').remove()
      return), 300
    $('#login-password').keyup (event) ->
      if event.keyCode == 13
        $('#login-submit  ').click()
      return
    $('#login-username').keyup (event) ->
      if event.keyCode == 13
        $('#login-submit').click()
      return
  $('#register').on 'click', ->
    setTimeout (->
      $('.modal-backdrop.fade.in').remove()
      return), 300
    $('#new-password-confirmation').keyup (event) ->
      if event.keyCode == 13
        $('#submit-registration').click()
      return
  $('button#showMenu').hide()
  $('button#showMenu2').hide()
  $('#login-form').formValidation
    excluded: ':disabled'
  $('#register-form').formValidation
    excluded: ':disabled'
  $('#login-submit').on 'click', ->
    $.ajax "/login",
      type: 'post'
      dataType: 'json'
      data:
        user:
          username: $('#login-username').val()
          password: $('#login-password').val()
      success: (data) ->
        window.location = '/'
      error: (data) ->
        if data.status == 401 || data.status == 500
            $('#login-username').css('border-color', 'red')
            $('#login-password').css('border-color', 'red')
            $('#login-hint').show()
            $('#login-hint').css('color', 'red')

  $('#submit-registration').on 'click', ->
    if $('#confirm-register-password').val() == $('#register-password').val()
      unless $('#register-username').parent().hasClass('has-error') || $('#register-email').parent().hasClass('has-error')
        $.ajax "/register",
          type: 'post'
          dataType: 'json'
          data:
            user:
              username: $('#register-username').val()
              display_name: $('#register-display-name').val()
              email: $('#register-email').val()
              password: $('#register-password').val()
          success: (data) ->
            bootbox.alert "You have been registered! Check #{$('#register-email').val()} for your registration link.", ->
              window.location = window.location
          error: (data) ->
            bootbox.alert "Error: #{data.error}, please try again.", ->
              null
      else
        if $('#register-username').parent().hasClass('has-error')
          $('#register-username-helper').show()
        else if $('#register-email').parent().hasClass('has-error')
          $('#register-email-helper').show()
    else
      $('#confirm-register-password').css('border-color', 'red')
      $('#register-password').css('border-color', 'red')
      $('#register-password-helper').show()
      $('#confirm-register-password-helper').show()
