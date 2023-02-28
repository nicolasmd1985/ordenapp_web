// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery
//= require jquery_ujs
//= require jquery.validate
//= require mdbootstrap/popper.min
//= require bootstrap
//= require mdbootstrap/mdb.min.js
//= require mdbootstrap/datatables.min
//= require mdbootstrap/datatables-select.min
//= require sweetalert2
//= require sweet-alert2-rails
//= require users
//= require popper
//= require sign_up
//= require orders
//= require welcome
//= require heatmap.js
//= require dashboard
//= require things
//= require tools
//= require categories
//= require account
//= require subsidiaries
//= require corporations
//= require notifications
//= require cable

$(document).ready(function() {
  // SideNav Button Initialization
  $(".button-collapse").sideNav2({
    breakpoint: 992
  });

/************SELECT INITIALIZATION**********/
  $('.mdb-select').materialSelect({
    validate: true,
    labels: {
      validFeedback: 'Correct choice',
      invalidFeedback: 'Wrong choice'
    }
  });

  $('.mdb-select #tool-tecnic, #devise-tecnic, #category-thing, #unit_category').materialSelect({
    validate: false,
    labels: {
      validFeedback: 'Correct choice',
      invalidFeedback: 'Wrong choice'
    }
  });

  // Set up As supervisor alert

  if($('.fa-toggle-on').length) {
    $('#alert_explanation').removeClass('display');
  } else {
    $('#alert_explanation').addClass('display');
  }

/* Set breadcrumb behaviour and active ítem menu on side nav */

  var url = $('#breadcrumb').text();
  var length = url.length;
  var link = url.substring(1, length - 1);
  var path = link.split('/')
  bc = $('<li class="breadcrumb-item"></li>');
  var item = ''
  $(path).each(function(n, element) {
    if ($('#slide-out .collapsible li').hasClass('active')) {
      menuItem = $('#slide-out .collapsible .active .collapsible-body').find('a[title="'+element+'"]').addClass("clicked");
      var a = $(menuItem).clone();
      bc.append(' / ', a);
    } else {
      menuItem = $('#slide-out .collapsible').find('a[data-original-title="'+element+'"]').addClass("clicked");
      $(menuItem).parent().addClass('active');
      //$('a.clicked + .collapsible-body').css('display', 'block');
      var a = $(menuItem).clone();
      bc.append(' / ', a);
    }
  });
  var lang = $('html').attr('lang');
  if (lang == "es") {
    $('.breadcrumb').html( bc.prepend('<a href="/">Inicio</a>'));
  } else {
    $('.breadcrumb').html( bc.prepend('<a href="/">Home</a>'));
  }
  $('.breadcrumb .clicked.no-link').css('cursor', 'default');
  $('.breadcrumb .clicked').addClass('no-bckgd');
  $('.breadcrumb .material-tooltip-main').tooltip('disable');

/* Set up side nav element behaviour */

  let isOpen = false;
  let $windowWidth = $( window ).width();
  const $btnCollapse = $(".button-collapse");
  const $logoCollapse = $('#nav-logo');
  const $content = $('#content');

  if ($windowWidth > 992) {
    $content.css('padding-left', '70px');
    $btnCollapse.css('left', '50px');
    $logoCollapse.css('left', '50px');
    $btnCollapse.click();
    $('#sidenav-overlay').css('display', 'none');
    isOpen = true;
  }
  else {
    $content.css('padding-left', '0');
    $btnCollapse.css('left', '0');
    $logoCollapse.css('left', '0');
    isOpen = false;
  }

  $btnCollapse.on('click', () => {
   isOpen = !isOpen;
   $windowWidth = $( window ).width();
   if($windowWidth > 992) {
    const sideNavPadding = isOpen ? '70px' : '0';
    const btnPadding = isOpen ? '50px' : '0';
    $btnCollapse.css('left', btnPadding);
    $logoCollapse.css('left', btnPadding);
   	$content.css('padding-left', sideNavPadding);
    $('#sidenav-overlay').css('display', 'none');
   } else {
    $('#sidenav-overlay').css('display', 'block');
    $btnCollapse.css('left', '0');
    $logoCollapse.css('left', '0');
    $content.css('padding-left', '0');
    $('#sidenav-overlay').on('click', () => {
      isOpen = !isOpen;
    });
   }
  });
  $('#sidenav-overlay').on('click', () => {
    isOpen = !isOpen;
  });
});
