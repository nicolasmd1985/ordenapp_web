/************FORM VALIDATION***********/
(function() {
    'use strict';
    window.addEventListener('load', function() {
      // Fetch all the forms we want to apply custom Bootstrap validation styles to
      var forms = document.getElementsByClassName('subsidiary_form');
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

(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('admin_subsidiary_form');
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

$(document).ready(function(){

  /*****CLICK TO UPLOAD IMAGE - SUBSIDIARY FORM*******/
  $('#subsidiary_form .clic-file').click(function(){
    $('#subsidiary_urlavatar').click();
  });

  /*********PREVIEW SELECTED IMAGE - SUBSIDIARY FORM************/
  if ($('#subsidiary_urlavatar').length) {  
    document.getElementById("subsidiary_urlavatar").onchange = function() {
      const fileList = event.target.files;
      // console.log(fileList);
      // console.log(fileList[0].name);
      var reader = new FileReader();
      reader.onload = function (e) {
          // get loaded data and render thumbnail.
          document.getElementById("subsidiary-logo").src = e.target.result;
      };
      // read the image file as a data URL.
      reader.readAsDataURL(this.files[0]);
      $('.file-name').text(fileList[0].name);
    };
  }

  /*****CLICK TO UPLOAD IMAGE - ADMIN SUBSIDIARY FORM*******/
  $('#admin_subsidiary_form .clic-file').click(function(){
    $('#admin-subsidiary-urlavatar').click();
  });

  /*********PREVIEW SELECTED IMAGE - ADMIN SUBSIDIARY FORM************/
  if ($('#admin-subsidiary-urlavatar').length) {  
    document.getElementById("admin-subsidiary-urlavatar").onchange = function() {
      const fileList = event.target.files;
      // console.log(fileList);
      // console.log(fileList[0].name);
      var reader = new FileReader();
      reader.onload = function (e) {
          // get loaded data and render thumbnail.
          document.getElementById("admin-subsidiary-logo").src = e.target.result;
      };
      // read the image file as a data URL.
      reader.readAsDataURL(this.files[0]);
      $('.file-name').text(fileList[0].name);
    };
  }
})
