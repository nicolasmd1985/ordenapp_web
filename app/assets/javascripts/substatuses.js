$(document).ready(function () {
    console.log("hola desde substatus");
    //*******SET UP TABLE FEATURES**********/
    $('#substatus-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false,
        targets: 1
        }],
        "scrollX": true,
    });
    $('#substatus-table_wrapper').find('label').each(function () {
    $(this).parent().append($(this).children());
    });
    $('#substatus-table_wrapper .dataTables_filter').find('input').each(function () {
    const $this = $(this);
    $this.attr("placeholder", "Search");
    $this.removeClass('form-control-sm');
    });
    $('#substatus-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#substatus-table_wrapper .dataTables_filter').addClass('md-form');
    $('#substatus-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#substatus-table_wrapper select').addClass('mdb-select');
    $('#substatus-table_wrapper .dataTables_filter').find('label').remove();
});

/************FORM VALIDATION***********/
(function() {
    'use strict';
    window.addEventListener('load', function() {
      // Fetch all the forms we want to apply custom Bootstrap validation styles to
      var forms = document.getElementsByClassName('substatus_form');
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
