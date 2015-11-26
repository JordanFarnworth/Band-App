# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Event
  constructor: ->
    @user = ENV.current_user
    @entity = ENV.current_entity
    @event_id = window.location.pathname.match(/\/events\/(\d+)/)[1]

  showMap: (lat, long) =>
    hash = {
      "name": $('#event-name').val(),
      "address": $('#event-address').val(),
      "latitude": lat,
      "longitude": long
      }
    gmap_show hash


  removeFromFavorites: (favorite) =>
    bootbox.confirm "Do you want to remove this band From your Favorites list?", (result) ->
      if result
        $.ajax "/favorites/add_remove_party",
          type: 'post'
          dataType: 'json'
          data:
            favorite:
              band_id: favorite.attr('id')
              party_id: ENV.current_entity
          success: (data) =>
            favorite.parent().parent().parent().remove()

  showHideAddToEventButton: () =>
    if $('#bands-to-invite').children().length > 0
      $('#add-band-to-event').show()
    else
      $('#add-band-to-event').hide()



  updateEvent: () =>

    $.ajax "/api/v1/events/#{@event_id}",
      type: 'put'
      dataType: 'json'
      data:
        event:
          title: $('#edit-event-title').val()
          description: $('#edit-event-description').val()
          start_time: moment().format($('#edit-event-st').val())
          end_time:  moment().format($('#edit-event-ed').val())
          price: $('#edit-event-price').val()
          address: $('#edit-event-address').val()
          is_public: if $('select').val() == "Public" then true else false
      success: (data) =>
        bootbox.alert "#{data.title} updated!", ->
          reload()

  checkIfAlreadyinvited: (band) =>
    band_id = "band-#{band}"
    response = null
    children = $('#bands-to-invite').children().each ->
      if $(this).attr('id') == band_id
        response = true
    return response

  addBandToInviteList: (band, band_name, e) =>
    if @checkIfAlreadyinvited(band) == null
      $('#bands-to-invite').append(bandInfo(band, band_name))
      new Event().initializeListeners()
      @showHideAddToEventButton()
    else
      bootbox.alert "this band is already on the invite list", ->
        null

  initializeListeners: () =>
    @kids = $('#bands-to-invite').children()

    @kids = $.map @kids, (obj, i) ->
      $("#" + obj.id).on 'click', ->
        $(@).remove()
        $(@).unbind()
        new Event().showHideAddToEventButton()


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

updateDate = () ->
  debugger
  start = $('#edit-event-st').val()
  start_frd = new Date(start).toLocaleTimeString()
  end = $('#edit-event-ed').val()
  end_frd = new Date(end).toLocaleTimeString()
  $('#edit-event-st').val(start_frd)
  $('#edit-event-ed').val(end_frd)
  $('#edit-event-st').datetimepicker()
  $('#edit-event-ed').datetimepicker()


reload = ->
  window.location = window.location

bandInfo = (band, band_name) ->
  "
    <div id='band-#{band}' class='list-group-item'>
      <h4 class='list-group-item-heading'>
      #{band_name}
      <span class='pull-right'>
          <a id='remove-#{band}'>
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
      if new Event().checkIfAlreadyinvited(ui.item.value) == null
        new Event().addBandToInviteList(ui.item.value, ui.item.name, event)
      else
        bootbox.alert "this band is already on the invite list", ->
          null
  }

$('.events.show').ready ->
  $('#edit-event-st').datetimepicker()
  $('#edit-event-st').val(new Date($('#edit-event-st').attr('name')).toLocaleString().replace(/:\d{2}\s/,' ').replace(/\,/, ''))
  $('#edit-event-ed').datetimepicker()
  $('#edit-event-ed').val(new Date($('#edit-event-ed').attr('name')).toLocaleString().replace(/:\d{2}\s/,' ').replace(/\,/, ''))
  $('#search-band').autocomplete autocompletePartyParams()
  $('#add-band-to-event').on 'click', ->
    new Event().inviteBands()
  $('#update-event').on 'click', ->
    new Event().updateEvent()
  $('.fav-list').on 'click', ->
      new Event().addBandToInviteList($(this).attr('id'), $(this).attr('name'), event)
  $('.trash-list').on 'click', ->
    new Event().removeFromFavorites($(this))
  new Event().showHideAddToEventButton()
  new Event().showMap($('#event-latitude').val(), $('#event-longitude').val())
