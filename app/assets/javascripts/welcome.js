$(document).ready(function(){
  $('#trigger_btn').on('click', function(event) {
    $('#youtube_video')[0].src += "&autoplay=1";
    event.preventDefault();
  });

  $('#video_presentation').on('loadstart', function() {
    $('#video_presentation').get(0).play();
  });


  $( ".welcome_title" ).slideUp( 300 ).delay( 5000 ).fadeIn( 400 );
  $( ".start_botton" ).slideUp( 300 ).delay( 5000 ).fadeIn( 400 );
  $(".demo").slideUp( 300 ).delay( 8000 ).fadeIn( 400 );

  $(".button_close").on('click', function(ev){
    $('#youtube_video')[0].src += "&mute=1";
    ev.preventDefault();
  });



});
