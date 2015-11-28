# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# jquery classList method, gives array of class names
# DONT DELETE, NEDED THIS FOR JQUERY
# Ex: <div id="test" class="foo bar"></div>
# $('#test').classList() => ['foo', 'bar']
$.fn.classList = ->
  @[0].className.split /\s+/

arrayContains = (needle, effect) ->
  arrhaystack.indexOf(needle) > -1

# Fragile, handle with care / function that allows perspective on one dive
# god forgive me
linkButtonToDiv = (jbs, class_name, list_id) ->
  $(jbs).on 'click', ->
    parent = $(jbs).parent().parent().parent().parent().parent()[0]
    arry = $(parent).classList()
    oldClass = arry[1]
    $(parent).removeClass(oldClass);
    $(parent).addClass("effect#{class_name}")
    $('nav').hide()
    $(list_id).show()

$ ->
  $('.container').css('width', '100%')
  linkButtonToDiv($("[name='sm']"), '-airbnb', '#effect-airbnb')
  linkButtonToDiv($("[name='smt']"), '-rotateleft', '#effect-moveleft')
  $("[data-action='togglePicker']").css("color", "red")
