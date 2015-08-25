# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('.messages.index').ready ->
  $('.index-row').click openThread

  match = window.location.hash.match(/m_id=(\d+)/)
  if match
    $(".index-row[data-message-thread-id=#{match[1]}]").click()

openThread = (e) ->
  $('.message-container *').remove()
  $('.message-container').append('<i class="fa fa-2x fa-pulse fa-spinner"></i>')
  target = if $(e.target).hasClass('index-row') then $(e.target) else $(e.target).parents('.index-row:first')
  thread_id = target.data('message-thread-id')
  $('.index-row').removeClass('active')
  target.addClass('active')
  $.ajax "/api/v1/message_threads/#{thread_id}/messages?include[]=sender",
    dataType: 'json'
    type: 'get'
    success: (data) ->
      $('.message-container i').remove()
      populateThread(data)

populateThread = (data) ->
  temp = Handlebars.compile($('#message_row_template').html())
  $.each data.results, (index, row) ->
    $('.message-container').append(temp(row))
