//= require jquery
//= require jquery_ujs
//= require jquery.validate
//= require mdbootstrap/mdb.min
//= require bootstrap
//= require popper
//= require demo_request
//= require sign_up
//= require auth


$(document).ready(function() {
  $('.full-page-intro.banner').parent().addClass('overflow-hidden');

  $('.toggle-password').on('click', function() {
      $(this).toggleClass('fa-eye-slash fa-eye');
      let input = $($(this).attr('toggle'));
      if (input.attr('type') == 'password') {
        input.attr('type', 'text');
      }
      else {
        input.attr('type', 'password');
      }
    });
});
