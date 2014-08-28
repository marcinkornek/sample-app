# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.enableScrolling = ->
  if $('.pagination').length && $('.users').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 250 && url != '#'
        $('.pagination').text("Fetching more users...")
        return if window.loadingUsers
        console.log url
        window.loadingUsers = true
        $.getScript(url).done(-> window.loadingUsers = false)
    $(window).scroll

window.disableScrolling = ->
  $(window).off('scroll')

window.hideMicropostsOnClick = ->
  $('.hide_microposts').on 'click', ->
    $('.microposts').toggle()
    $(this).toggleText("Hide microposts","Show microposts")


window.userSearchAutocomplete = ->
  $('#search').autocomplete
    source: $('#search').data('autocomplete-source')
    minLength: 2
    autoFocus: true

window.buttonEnableEndlessScrolling = ->
  $('.enable_scrolling_button').on 'click', ->
    $(this).addClass('active')
    enableScrolling()
    $('.disable_scrolling_button').removeClass('active')
    console.log 'a'

window.buttonDisableEndlessScrolling = ->
  $('.disable_scrolling_button').on 'click', ->
    $(this).addClass('active')
    disableScrolling()
    $('.enable_scrolling_button').removeClass('active')
    console.log 'b'

window.changeNavbarColor = ->
  $('.change-navbar-color').on 'click', ->
    $(this).toggleClass('active')
    $('#logo').toggleClass('active')
    $(this).toggleText("black","gray")
    navbar = $('.navbar.navbar-fixed-top')
    if  navbar.hasClass('navbar-inverse')
      navbar.removeClass('navbar-inverse')
      navbar.addClass('navbar-default')
      $.cookie('navbar_color', 'gray', { path: '/' });
    else
      navbar.removeClass('navbar-default')
      navbar.addClass('navbar-inverse')
      $.cookie('navbar_color', 'black', { path: '/' });
    console.log 'c'

window.checkNavbarColor = ->
  navbar = $('.navbar.navbar-fixed-top')
  button = $('.change-navbar-color')
  if $.cookie('navbar_color') == 'gray'
    navbar.removeClass('navbar-inverse')
    navbar.addClass('navbar-default')
    button.toggleClass('active')
    button.text("black")
    $('#logo').toggleClass('active')
  console.log 'd'

$ ->
  hideMicropostsOnClick()
  jQuery("time.timeago").timeago()
  userSearchAutocomplete()
  buttonEnableEndlessScrolling()
  buttonDisableEndlessScrolling()
  changeNavbarColor()
  checkNavbarColor()
