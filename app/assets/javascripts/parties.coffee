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

$('.parties.show').ready ->
  new Party().getPartyInfo()
