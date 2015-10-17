# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Event
  constructor: ->
    @user = ENV.current_user
    @entity = ENV.current_entity
    @event_id = window.location.pathname.match(/\/events\/(\d+)/)[1]

  updateEvent: () =>
    $.ajax "/api/v1/events/#{@event_id}",
      type: 'put'
      dataType: 'json'
      data:
        event:
          title: $('#edit-event-title').val()
          description: $('#edit-event-description').val()
          start_time: $('#edit-event-st').val()
          end_time: $('#edit-event-ed').val()
          price: $('#edit-event-price').val()
      success: (data) =>
        bootbox.alert "#{data.title} updated!", ->
          reload()




  addBandToInviteList: (band, band_name, e) =>
    if e.target.class == 'fav-list'
      # TO DO add favorites to invite list
    else
      $('#bands-to-invite').append(bandInfo(band, band_name))
      new Event().initializeListeners()

  initializeListeners: () =>
    @kids = $('#bands-to-invite').children()
    @kids = $.map @kids, (obj, i) ->
      $("#" + obj.id).on 'click', ->
        $(@).remove()
        $(@).unbind()


  inviteBands: () =>
    bands = []
    @kids = $('#bands-to-invite').children()
    @kids = $.map @kids, (obj, i) ->
      id = obj.id.match(/\d+/)[0]
      bands.push(id)
    $.ajax "/api/v1/events/#{@event_id}/invite",
      type: 'post'
      dataType: 'json'
      data:
        bands: bands
      success: (data) =>
        bootbox.alert("Bands Invited", null)


reload = ->
  window.location = window.location

bandInfo = (band, band_name) ->
  "
    <div id='band-#{band}' class='list-group-item'>
      <h4 class='list-group-item-heading'>
      #{band_name}
      <span class='pull-right'>
          <a href='#' id='remove-#{band}'>
            <i class='fa fa-minus-circle'></i>
          </a>
        <span>
      </h4>
    </div>
  "


autocompletePartyParams = ->
  {
    minLength: 2
    source:(request, response) ->
      $.ajax
        url: "/api/v1/bands",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data['results'], (obj, i) ->
            {label: obj.name, value: obj.id, obj: obj, name: obj.name}
          response data
    select:(event, ui) ->
      event.preventDefault()
      return unless ui.item
      $('#search-band').val('')
      new Event().addBandToInviteList(ui.item.value, ui.item.name, event)
  }

$('.events.show').ready ->
  $('#search-band').autocomplete autocompletePartyParams()
  $('#add-band-to-event').on 'click', ->
    new Event().inviteBands()
  $('#update-event').on 'click', ->
    new Event().updateEvent()
  $('#edit-event-st').datetimepicker()
  $('#edit-event-ed').datetimepicker()
