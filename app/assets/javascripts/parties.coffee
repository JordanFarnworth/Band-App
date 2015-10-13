# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Party
  constructor: ->
    @party = window.location.pathname.match(/\/parties\/(\d+)/)[1]

  getPartyInfo: =>
    $.ajax "/api/v1/parties/#{@party}",
      type: 'get'
      dataType: 'json'
      success: (data) =>
        console.log data
        gmap_show data
        @populatePartyPage data

  createApplication: =>
    $.ajax "/api/v1/application",
      type: 'post'
      dataType: 'json'
      data:
        application:
          start_time: $('#application-start').val()
          end_time: $('#application-end').val()
          party_id: window.location.pathname.match(/\/parties\/(\d+)/)[1]
          band_id: ENV.current_entity
      success: (data) =>
        $('#application-modal').modal('hide')
        bootbox.alert('Your application has been created and delivered!', null)
        $('#band-application-div').addClass('hidden')



  populatePartyPage: (data) =>
    @compileHbsTemplate("party-name-hbs", "party-name", data)
    @compileHbsTemplate("party-owner-name-hbs", "party-owner", data)
    @compileHbsTemplate("party-created-at-hbs", "party-created-at", data)
    @compileHbsTemplate("party-social-media-hbs", "party-social-media", data.social_media)
    @compileHbsTemplate("party-general-info-hbs", "party-general-info", data)


  validateParsely: (pass, id) =>
    if pass == true
      $('#' + id).css('color', 'white')
    else
      $('#' + id).css('color', 'red')

  compileHbsTemplate: (hbsid, elid, data) ->
    template = Handlebars.compile($("script#" + hbsid).html())
    temp = $(template(data))
    $("#" + elid).html(temp)

autocompletePartyParams = ->
  {
    appendTo: '#party-search-results'
    minLength: 3
    source:(request, response) ->
      $.ajax
        url: "/api/v1/parties",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data['results'], (obj, i) ->
            {label: obj.name, value: obj.id, obj: obj}
          response data
    select:(event, ui) ->
      event.preventDefault()
      return unless ui.item
      $('#party-simple-search-bar').val('')
      window.location = "/parties/#{ui.item.value}"
  }


$('.parties.show').ready ->
  new Party().getPartyInfo()
  $('#application-start').datepicker()
  $('#application-end').datepicker()
  $('#create-normal-application').on 'click', ->
    new Party().createApplication()

$('.parties.search').ready ->
  $('#party-search-form label').css({'font-size': '24px', 'color': '#2ECBFF'})
  $('#party-simple-search-bar').autocomplete autocompletePartyParams()
  $('#simple-search-tab').click()