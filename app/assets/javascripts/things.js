$(document).ready(function () {

  //*******CLEAR BUTTON FUNCTION ON FILTERS FORM**********//  
  $('#cancel_search').css('cursor', 'pointer');
  $('#cancel_search').click(function(){
    var lng = document.documentElement.lang;
    $('#search').val('');
    $('#things-filter-form #status').val('');
    $('#things-filter-form #customer').val('');
    if (lng == "es") {
      $('#filterbar > #things-filter-form > div:last-child > div:nth-child(2) > div > input').val('Estado');
      $('#filterbar > #things-filter-form > div:last-child > div:nth-child(3) > div > input').val('Cliente');
    } else {      
      $('#filterbar > #things-filter-form > div:last-child > div:nth-child(2) > div > input').val('Status');
      $('#filterbar > #things-filter-form > div:last-child > div:nth-child(3) > div > input').val('Customer');
    }
  });

  //*******SET UP TABLE FEATURES**********/
    $('#device-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false
        }],
        // "fnInitComplete": function () {
        //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
        //   var ps = new PerfectScrollbar(myCustomScrollbar);
        // },
        "scrollX": true,
      });
    $('#device-table_wrapper').find('label').each(function () {
      $(this).parent().append($(this).children());
    });
    $('#device-table_wrapper .dataTables_filter').find('input').each(function () {
      const $this = $(this);
      $this.attr("placeholder", "Search");
      $this.removeClass('form-control-sm');
    });
    $('#device-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#device-table_wrapper .dataTables_filter').addClass('md-form');
    $('#device-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#device-table_wrapper select').addClass('mdb-select');
    $('#device-table_wrapper .dataTables_filter').find('label').remove();

    /****************LIMIT TEXT LENGTH ON TABLE******************/
  $(".limitado").each(function() {
    var max_chars = 15;
    limit_text = $(this).text();
    if (limit_text.length > max_chars) {
      limit = limit_text.substr(0, max_chars)+" ...";
      $(this).text(limit);
    }
  });

  /*****CLICK TO UPLOAD IMAGE*******/
  $('#thing_form .clic-file, #edit_thing .clic-file').click(function(){
    $('#thing_urlavatar').click();
  });

  /*********PREVIEW SELECTED IMAGE************/
  if ($('#thing_urlavatar').length) {
    document.getElementById("thing_urlavatar").onchange = function() {
      const fileList = event.target.files;
      // console.log(fileList);
      // console.log(fileList[0].name);
      var reader = new FileReader();
      reader.onload = function (e) {
          // get loaded data and render thumbnail.
          document.getElementById("thing-image").src = e.target.result;
      };
      // read the image file as a data URL.
      reader.readAsDataURL(this.files[0]);
      $('.file-name').text(fileList[0].name);
    };
  }
});

/************FORM VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('thing_form');
    // Loop over them and prevent submission
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
