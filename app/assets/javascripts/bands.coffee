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
        if data.favorite == 'true'
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star fa-6"></i></a></h1>
          <em>Favorited!</em>')
        else
          $('.favorite-band-div').html('<h1><a href="#"><i id="favorite-band" class="fa fa-star-o fa-6"></i></a></h1>
          <em>Favorite This Band?</em>')
        $('i#favorite-band').on 'click', ->
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

advanceSearchBands = () ->
  name = $('#band-name-asearch').val()
  genre = $('#band-genre-asearch').val()
  email = $('#band-email-asearch').val()
  miles = $('#miles-away').val()
  $('#advanced-search-well').hide()
  $('#advanced-search-div').append(
    "<div id='searching-icon' class=\"text-center\">
      <h1 style='color: white;'>Searching<h1>
      <i style='color: white;' class=\"fa fa-refresh fa-spin\"></i>
    </div>
    "
  )
  $.ajax "/api/v1/bands/advanced_search",
    type: "post"
    dataType: "json"
    data:
      band:
        search_params:
          name: name
          genre: genre
          miles: miles
          email: email
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
                <a href='/bands/#{this.id}' style='color: white;'><h1>#{this.name}</h1></a>
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

setListeners = () ->
    $('#advanced-band-search-btn').on 'click', ->
      advanceSearchBands()

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

setBackground = (index) ->
  @IMAGES_URLS = []
  $.each $('#image-urls img'), (i) ->
    IMAGES_URLS.push $(this).attr('src')
  $('.container').css('background-image', 'url("' + @IMAGES_URLS[index] + '")')


$('.bands.search').ready ->
  setBackground(6)
  setListeners()
  $('#bands-search-form label').css({'font-size': '24px', 'color': '#2ECBFF'})
  $('#band-simple-search-bar').autocomplete autocompleteBandParams()
