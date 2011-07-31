// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).observe('dom:loaded', function() {
  $$('.youtube_button').each(function(el) {
    el.observe('click', function(event) {
      $(this).up('.link').down('.youtube_video').toggle();
      event.stop();
    });
  });
});