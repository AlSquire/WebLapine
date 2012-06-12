# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready () ->
  $('.line a').live 'click', (event) ->
    window.open $(this).attr('href')
    event.preventDefault()
  $('.youtube_button').live 'click', (event) ->
      $(this).parents('.link').children('.youtube_video').toggle()
      event.preventDefault()
  $('.image_button').live 'click', (event) ->
      $(this).parents('.link').children('.image').toggle()
      event.preventDefault()

  $('.show_all').live 'click', (event) ->
    $('.link').children('.image, .youtube_video').show()
    event.preventDefault()

  $('.search').children('input[type=text]').focus (event) -> $(event.target).select()