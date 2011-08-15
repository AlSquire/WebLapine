# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# $(document).observe('dom:loaded', function() {
#   $$('.youtube_button').each(function(el) {
#     el.observe('click', function(event) {
#       $(this).up('.link').down('.youtube_video').toggle();
#       event.stop();
#     });
#   });
# });
$(document).ready () ->
  $('.youtube_button').live 'click', (event) ->
      $(this).parents('.link').children('.youtube_video').toggle()
      event.preventDefault()