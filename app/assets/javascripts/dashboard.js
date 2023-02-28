function initMap() {
  // navigator.geolocation.getCurrentPosition(function(position){ solo para https
    $('.coords').css('display', 'none');

    let lat = '';
    let lng = '';
    const names = [];
    const statuses = [];
    const coords = [];
    const coordenates = [];

    $(".coords tr").each(function(index, item){
      coords.push(index);
      $(this).attr('id', "" +index+ "");
    })

    for(var i = 0; i < coords.length; i++){
      if (isNaN($('#' + i + ' td').data('lat')) == false) {
        lat = $('#' + i + ' td').data('lat');
        lng = $('#' + i + ' td').data('lng');
        name = $('#' + i + ' td').data('name');
        status = $('#' + i + ' td').data('status');
        coordenates.push({lat: lat, lng: lng});
        names.push(name);
        statuses.push(status)
      }
    }

    // let currentLatitude = position.coords.latitude;
    // let currentLongitude = position.coords.longitude;
    // currentLocation = {lat: currentLatitude, lng: currentLongitude}

    var loc = {lat: $('#map').data('latitude'), lng: $('#map').data('longitude')};
    var imalink = $('#map').data('image').split('"');
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 12, // Tweak this to your needs
      center: loc //currentLocation.lat ? currentLocation : loc
    });

    // Custom icon if you want one
    var icon = {
      url: imalink[1],
      scaledSize: new google.maps.Size(25, 25), // scaled size
      origin: new google.maps.Point(0,0), // origin
      anchor: new google.maps.Point(0, 0), // anchor
    };

    // map markers
    let openInfowindow;
    let statusClass = 'status-red';
    for (var i = 0; i < coordenates.length; i++) {
      var marker = new google.maps.Marker({
        position: coordenates[i],
        map: map,
        icon: icon,
        title: names[i],
        animation: google.maps.Animation.DROP
      });

      switch (statuses[i]) {
        case "Available":
        statusClass = 'status-green'
        case "Active":
        statusClass = 'status-green'
        break;
        case "Busy":
        statusClass = 'status-orange'
        break;
        case "On the way":
        statusClass = 'status-blue'
        break;
        default:
        statusClass = 'status-red'
      }

      var content = '<p><strong>Tecnic: ' + names[i] + '</strong>' +
      '<p><strong>Status: ' + statuses[i] + '<div class="' + statusClass + '"></div></strong>';
      var infowindow = new google.maps.InfoWindow();

      google.maps.event.addListener(marker,'click', (function(marker,content,infowindow){
        return function() {
          if (openInfowindow){
            openInfowindow.close();
          }
          infowindow.setContent(content);
          openInfowindow = infowindow;
          infowindow.open(map,marker);
        };

      })(marker,content,infowindow));

    }

  // });  solo para https
}
//*******SET UP TABLE FEATURES**********/
$(document).ready(function(){
  /*******ORDERS TABLE********/
  $('#order-table-dash').DataTable({
    // "aaSorting": [],
    // columnDefs: [{
    // orderable: false,
    // targets: [ 6, 7]
    // }],
    // "fnInitComplete": function () {
    //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
    //   var ps = new PerfectScrollbar(myCustomScrollbar);
    // },
    "scrollX": true,
  });
  $('#order-table-dash_wrapper').find('label').each(function () {
  $(this).parent().append($(this).children());
  });
  $('#order-table-dash_wrapper .dataTables_filter').find('input').each(function () {
    const $this = $(this);
    $this.attr("placeholder", "Search");
    $this.removeClass('form-control-sm');
  });
  $('#order-table-dash_wrapper .dataTables_length').addClass('d-flex flex-row');
  $('#order-table-dash_wrapper .dataTables_filter').addClass('md-form');
  $('#order-table-dash_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
  $('#order-table-dash_wrapper select').addClass('mdb-select');
  $('#order-table-dash_wrapper .dataTables_filter').find('label').remove();

  /*******FINISHED ORDERS TABLE********/
  $('#orderf-table-dash').DataTable({
    // "aaSorting": [],
    // columnDefs: [{
    // orderable: false,
    // targets: [ 6, 7]
    // }],
    // "fnInitComplete": function () {
    //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
    //   var ps = new PerfectScrollbar(myCustomScrollbar);
    // },
    "scrollX": true,
  });
  $('#orderf-table-dash_wrapper').find('label').each(function () {
  $(this).parent().append($(this).children());
  });
  $('#orderf-table-dash_wrapper .dataTables_filter').find('input').each(function () {
    const $this = $(this);
    $this.attr("placeholder", "Search");
    $this.removeClass('form-control-sm');
  });
  $('#orderf-table-dash_wrapper .dataTables_length').addClass('d-flex flex-row');
  $('#orderf-table-dash_wrapper .dataTables_filter').addClass('md-form');
  $('#orderf-table-dash_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
  $('#orderf-table-dash_wrapper select').addClass('mdb-select');
  $('#orderf-table-dash_wrapper .dataTables_filter').find('label').remove();

  /*******REQUESTED ORDERS TABLE********/
  $('#orderR-table-dash').DataTable({
    // "aaSorting": [],
    // columnDefs: [{
    // orderable: false,
    // targets: [ 6, 7]
    // }],
    // "fnInitComplete": function () {
    //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
    //   var ps = new PerfectScrollbar(myCustomScrollbar);
    // },
    "scrollX": true,
  });
  $('#orderR-table-dash_wrapper').find('label').each(function () {
  $(this).parent().append($(this).children());
  });
  $('#orderR-table-dash_wrapper .dataTables_filter').find('input').each(function () {
    const $this = $(this);
    $this.attr("placeholder", "Search");
    $this.removeClass('form-control-sm');
  });
  $('#orderR-table-dash_wrapper .dataTables_length').addClass('d-flex flex-row');
  $('#orderR-table-dash_wrapper .dataTables_filter').addClass('md-form');
  $('#orderR-table-dash_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
  $('#orderR-table-dash_wrapper select').addClass('mdb-select');
  $('#orderR-table-dash_wrapper .dataTables_filter').find('label').remove();

  // Tooltips initialization and setup

  $(function () {
    $('.material-tooltip-main').tooltip({
      template: '<div class="tooltip md-tooltip-main"><div class="tooltip-arrow md-arrow"></div><div class="tooltip-inner md-inner-main tooltip-content"></div></div>'
    });
  })
  $('.collapsible-header').tooltip({ boundary: 'viewport' });

  $('.collapsible #toggle').click(function(){
    $('#slide-out').toggleClass('expanded')
    if($('#slide-out').hasClass('expanded')) {
      $('.expanded .material-tooltip-main').tooltip('disable');
    } else {
      $('#slide-out .material-tooltip-main').tooltip('enable');
    }
  })

  // Update tooltip position on menu item click

  $('.collapsible .collapsible-header').click(function(){
    $(this).tooltip('update')
    $(this).tooltip('hide')
  })

  $('.avatar .dropdown-toggle').click(function(){
    $('.material-tooltip-main').tooltip('hide')
  });

  $('#content .nav-tabs > li:last-child a').click(function() {
    setTimeout(
      function() 
      {
        $('#orderR-table-dash_wrapper .dataTables_scrollHeadInner thead tr > th:first-child').delay(1000).click()
        $('#orderR-table-dash_wrapper .dataTables_scrollHeadInner thead tr > th:first-child').delay(1000).click()
      }, 200);        
  })
})
  

