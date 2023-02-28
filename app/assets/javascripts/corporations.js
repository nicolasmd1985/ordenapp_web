/************FORM VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('corporation_form');
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

$(document).ready(function () {
    //*******SET UP TABLE FEATURES**********/
    $('#corporation-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false,
        targets: 7
        }],
        "order": [[ 0, "desc" ]],
        "scrollX": true,
    });
    $('#corporation-table_wrapper').find('label').each(function () {
      $(this).parent().append($(this).children());
    });
    $('#corporation-table_wrapper .dataTables_filter').find('input').each(function () {
      const $this = $(this);
      $this.attr("placeholder", "Search");
      $this.removeClass('form-control-sm');
    });
    $('#corporation-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#corporation-table_wrapper .dataTables_filter').addClass('md-form');
    $('#corporation-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#corporation-table_wrapper select').addClass('mdb-select');
    $('#corporation-table_wrapper .dataTables_filter').find('label').remove();


    /*****CLICK TO UPLOAD IMAGE*******/
  $('#corporation_form .clic-file').click(function(){
    $('#corporation-urlavatar').click();
  });

  /*********PREVIEW SELECTED IMAGE************/
  if ($('#corporation-urlavatar').length) {
    document.getElementById("corporation-urlavatar").onchange = function() {
      const fileList = event.target.files;
      // console.log(fileList);
      // console.log(fileList[0].name);
      var reader = new FileReader();
      reader.onload = function (e) {
          // get loaded data and render thumbnail.
          document.getElementById("corporation-logo").src = e.target.result;
      };
      // read the image file as a data URL.
      reader.readAsDataURL(this.files[0]);
      $('.file-name').text(fileList[0].name);
    };
  }

  /***************START TAWK TO**************/


  var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
  (function(){
    var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;
    s1.src='https://embed.tawk.to/60185793a9a34e36b972b638/1etfhc5vr';
    s1.charset='UTF-8';
    s1.setAttribute('crossorigin','*');
    s0.parentNode.insertBefore(s1,s0);
  })();

});

window.addEventListener("load", function(){
  //alert('hola')
  $('#corporation-table_wrapper .dataTables_scrollHeadInner thead tr > th:first-child').delay(1000).click()
  $('#corporation-table_wrapper .dataTables_scrollHeadInner thead tr > th:first-child').delay(1000).click()
});
