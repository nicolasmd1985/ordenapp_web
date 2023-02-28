$(document).ready(function(){

  $('.all_notifications').removeClass("waves-effect waves-light")

  // $('.notify a').click(function(e){
  //   var notification = e.target.id;
  //   read_notification(notification);
  // });

  // notifications index
  $('#notifications_table td a').click(function(e){
    var notification = e.target.id;
    read_notification(notification);
  });

  function read_notification(notification){
    var protocol = location.protocol;
    var host = location.host;
    var service = '/api/v1/notifications/read/' + notification;
    var url = protocol + '//' + host + service;

    fetch(url)
    .catch(error => {
      console.log("Ha ocurrido un error.");
    })

  }
})
