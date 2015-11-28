# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#new_user').formValidation()

$('.login.landing').ready ->
  #TODO fix this frd
  $('#login').on 'click', ->
    setTimeout (->
      $('.modal-backdrop.fade.in').remove()
      return), 300
  $('#register').on 'click', ->
    setTimeout (->
      $('.modal-backdrop.fade.in').remove()
      return), 300
