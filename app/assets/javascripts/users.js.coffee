# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # if $('.pagination').length
  #   $(window).scroll ->
  #     url = $('.pagination .next_page a').attr('href')
  #     if url && $(window).scrollTop() > $(document).height() - $(window).height() - 250
  #       $('pagination').text("Fetching more users...")
  #       console.log url
  #       $.getScript(url)
  #   $(window).scroll

  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 250
        $('pagination').text("Fetching more users...")
        return if window.loadingUsers
        console.log url
        window.loadingUsers = true
        $.getScript(url).done(-> window.loadingUsers = false)
    $(window).scroll

# window.greet = (message, message2) ->
#   alert "#{message} #{message2} "

# greet("asd", "pol")

# # window.greet = (name="Stranger") ->
#   # alert "#{name}"

