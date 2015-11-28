# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Band
  constructor: ->
    @band = window.location.pathname.match(/\/bands\/(\d+)/)[1]

  checkFavorite: (party, band) =>
    $.ajax "/favorites/check_party",
      type: 'post'
      dataType: 'json'
      data:
        band_id: band
        party_id: party
      success: (data) =>
        console.log 'data from check fav' + data.favorite
        if data.favorite == 'true'
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star fa-6"></i></a></h1>
          <em>Favorited!</em>')
        else
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star-o fa-6"></i></a></h1>
          <em>Favorite This Band?</em>')
        $('i#favorite-band').on 'click', ->
          console.log 'this is getting clicked'
          @band = window.location.pathname.match(/\/bands\/(\d+)/)[1]
          new Band().addRemoveFavorite(@band, ENV.current_entity)

  addRemoveFavorite: (band, party) =>
    $.ajax "/favorites/add_remove_party",
      type: 'post'
      dataType: 'json'
      data:
        favorite:
          band_id: band
          party_id: party
          owner: 'party'
      success: (data) =>
        console.log data
        $('i#favorite-band').on 'click', ->
          new Band().addRemoveFavorite(@band, ENV.current_entity)
        if data.deleted == 'true'
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star-o fa-6"></i></a></h1>
          <em>Favorite This Company?</em>')
        else
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star fa-6"></i></a></h1>
          <em>Favorited!</em>')

        $('i#favorite-band').on 'click', ->
          @band = window.location.pathname.match(/\/bands\/(\d+)/)[1]
          new Band().addRemoveFavorite(@band, ENV.current_entity)


  getBandData: =>
    $.ajax "/api/v1/bands/#{@band}",
      type: 'get'
      dataType: 'json'
      success: (data) ->
        new Band().populatePage(data)

  populatePage: (band) =>
    @compileHbsTemplate("band-social-media", "social-media", band.social_media)
    @compileHbsTemplate("band-contact-data", "contact-info", band.data)
    @compileHbsTemplate("band-description", "description", band)
    @compileHbsTemplate("band-name", "band-name", band)
    @compileHbsTemplate("band-youtube-video", "youtube-video", band.data)
    @compileHbsTemplate("band-music-sample", "band-music-sample-show", band.data)
    @compileHbsTemplate("band-reviews", "reviews", band)

  compileHbsTemplate: (hbsid, elid, data) =>
    template = Handlebars.compile($("script#" + hbsid).html())
    temp = $(template(data))
    $("#" + elid).html(temp)

autocompleteBandParams = ->
  {
    appendTo: '#band-search-results'
    minLength: 3
    source:(request, response) ->
      $.ajax
        url: "/api/v1/bands",
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
      $('#band-simple-search-bar').val('')
      window.location = "/bands/#{ui.item.value}"
  }

$('.bands.show').ready ->
  @band = window.location.pathname.match(/\/bands\/(\d+)/)[1]
  new Band().getBandData()
  $('#sticky-buttons').sticky topSpacing: 50
  new Band().checkFavorite(ENV.current_entity, @band)

$('.bands.search').ready ->
  $('#bands-search-form label').css({'font-size': '24px', 'color': '#2ECBFF'})
  $('#band-simple-search-bar').autocomplete autocompleteBandParams()
