# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

modalHelper = (jquery_selector) ->
  $(jquery_selector).on 'click', ->
    setTimeout (->
      $('.modal-backdrop.fade.in').remove()
      return), 300

class Party
  constructor: ->
    @party = window.location.pathname.match(/\/parties\/(\d+)/)[1]

  applyForEvent: (id) =>
    bootbox.confirm "Are you sure you want to apply for this event?", (result) ->
      new Party().createEventJoiner(id)

  createEventJoiner: (id) =>
    $.ajax '/api/v1/event_joiners',
    type: 'post'
    dataType: 'json'
    data:
      event_joiner:
        event_id: id
        entity_id: ENV.current_entity
        status: 'application'
    success: (data) =>
      bootbox.alert "Application has been sent! Check your dashboard for updates.", (result) ->
        console.log result
        window.location = window.location

  addRemoveFavorite: (party, band) =>
    $.ajax "/favorites/add_remove_band",
      type: 'post'
      dataType: 'json'
      data:
        favorite:
          band_id: band
          party_id: party
          owner: 'band'
      success: (data) =>
        $('i#favorite-party').on 'click', ->
          new Party().addRemoveFavorite(@party, ENV.current_entity)
        if data.deleted == 'true'
          $('.favorite-party-div').html('<h1><a href="#"><i id="favorite-party" class="fa fa-star-o fa-6"></i></a></h1>
          <em>Favorite This Company?</em>')
        else
          $('.favorite-party-div').html('<h1><a href="#"><i id="favorite-party" class="fa fa-star fa-6"></i></a></h1>
          <em>Favorited!</em>')

        $('i#favorite-party').on 'click', ->
          @party = window.location.pathname.match(/\/parties\/(\d+)/)[1]
          new Party().addRemoveFavorite(@party, ENV.current_entity)

  checkFavorite: (party, band) =>
    $.ajax "/favorites/check_band",
      type: 'post'
      dataType: 'json'
      data:
        band_id: band
        party_id: party
      success: (data) =>
        if data.favorite == 'true'
          $('.favorite-party-div').html('<h1><a href="#"><i id="favorite-party" class="fa fa-star fa-6"></i></a></h1>
          <em>Favorited!</em>')
        else
          $('.favorite-party-div').html('<h1><a href="#"><i id="favorite-party" class="fa fa-star-o fa-6"></i></a></h1>
          <em>Favorite This Company?</em>')

        $('i#favorite-party').on 'click', ->
          @party = window.location.pathname.match(/\/parties\/(\d+)/)[1]
          new Party().addRemoveFavorite(@party, ENV.current_entity)

  getPartyInfo: =>
    $.ajax "/api/v1/parties/#{@party}",
      type: 'get'
      dataType: 'json'
      success: (data) =>
        gmap_show data
        @populatePartyPage data

  createApplication: =>
    $.ajax "/api/v1/applications",
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
        bootbox.alert('Your application has been created and delivered!', ->
          if confirm then window.location = window.location)



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

advanceSearchParties = () ->
  name = $('#company-name-asearch').val()
  owner = $('#company-owner-asearch').val()
  miles = $('#miles-away').val()
  $('#advanced-search-well').hide()
  $('#advanced-search-div').append(
    "<div id='searching-icon' class=\"text-center\">
      <h1 style='color: white;'>Searching<h1>
      <i style='color: white;' class=\"fa fa-refresh fa-spin\"></i>
    </div>
    "
  )
  $.ajax "/api/v1/parties/advanced_search",
    type: "post"
    dataType: "json"
    data:
      party:
        search_params:
          name: name
          owner: owner
          miles: miles
    success: (data) ->
      $('#searching-icon').remove()
      if data.results == []
        $('.results').append(
          "
            <div class='text-center'>
              <h1 style='color: white;'>No Results</h1>
            </div>
          "
        )
      else
        $.each JSON.parse(data.results), (i) ->
          $('.results').append(
            "
              <div class='row text-center'>
                <a href='/parties/#{this.id}' style='color: white;'><h1>#{this.name}</h1></a>
              </div>
            "
          )
      $('.results').append(
        "
        <div class='row text-center'>
          <button id='search-again' class='btn btn-default'>Search Again</button>
        </div>
        "
      )
      $('#search-again').on 'click', ->
        $('.results').empty()
        $('#advanced-search-well').show()




$('.parties.show').ready ->
  @party = window.location.pathname.match(/\/parties\/(\d+)/)[1]
  new Party().getPartyInfo()
  $('#application-start').datetimepicker()
  $('#application-end').datetimepicker()
  $('#create-normal-application').on 'click', ->
    new Party().createApplication()
  new Party().checkFavorite(@party, ENV.current_entity)
  $('.btn.btn-default.apply-to-event').on 'click', ->
    new Party().applyForEvent($(@).attr('id'))
  modalHelper('#app-show-modal')

setBackground = (index) ->
  @IMAGES_URLS = []
  $.each $('#image-urls img'), (i) ->
    IMAGES_URLS.push $(this).attr('src')
  $('.container').css('background-image', 'url("' + @IMAGES_URLS[index] + '")')

setListeners = () ->
  $('#advanced-party-search-btn').on 'click', ->
    advanceSearchParties()

$('.parties.search').ready ->
  setBackground(6)
  setListeners()
  $('#party-search-form label').css({'font-size': '24px', 'color': '#ffffff'})
  $('#party-simple-search-bar').autocomplete autocompletePartyParams()
  $('#simple-search-tab').click()
