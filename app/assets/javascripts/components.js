$(document).ready(function () {

  if ($('#cancel_search').length) {
    $('#cancel_search').css('cursor', 'pointer');
    $('#cancel_search').click(function(){
      $('#search').val('');
      $('#thing').val('');
    });
  }


  //*******SET UP TABLE FEATURES**********/
    $('#component-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false
        }],
        "scrollX": true,
      });
    $('#component-table_wrapper').find('label').each(function () {
      $(this).parent().append($(this).children());
    });
    $('#component-table_wrapper .dataTables_filter').find('input').each(function () {
      const $this = $(this);
      $this.attr("placeholder", "Search");
      $this.removeClass('form-control-sm');
    });
    $('#component-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#component-table_wrapper .dataTables_filter').addClass('md-form');
    $('#component-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#component-table_wrapper select').addClass('mdb-select');
    $('#component-table_wrapper .dataTables_filter').find('label').remove();

    /****************LIMIT TEXT LENGTH ON TABLE******************/
  $(".limitado").each(function() {
    var max_chars = 15;
    limit_text = $(this).text();
    if (limit_text.length > max_chars) {
      limit = limit_text.substr(0, max_chars)+" ...";
      $(this).text(limit);
    }
  });

  $('#search_component_thing').on('keyup', function(){
    if ($('#search_component_thing').val().length >= 3) {
      search_devise();
    }
  });

  function search_devise(){
    var protocol = location.protocol;
    var host = location.host;
    var user_email = $('#user_email').val();
    var url = '/api/v1/things/search/?user_email=' + user_email + '&&name='

    fetch(protocol + '//' + host + url + $('#search_component_thing').val())
    .then(res => res.json())
    .then(data => {
      let devices = data.data;
      $('#component_thing_id').empty();

      if (devices.length > 0) {
        devices.forEach((device, i) => {
          $('#component_thing_id').append('<option value="' + device.id +'">' + device.name + '</option>');
        });
        $('#component_thing_id').removeAttr('disabled');
        $('#component_thing_id').css('display', 'block');
      } else {
        $('#component_thing_id').append('<option>No results</option>');
        $('#component_thing_id').attr('disabled', 'true')
      }
    })
    .catch(error => {
      console.log("Ha ocurrido un error.");
    })
  }

});

/************FORM VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('component_form');
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
