//= require jquery
//= require heatmap.js

function openModal(modalId) {
    $(`#${modalId}`).modal("show");
    $('#toast-container').hide();
}


/************REQUEST DEMO FORMS VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('demo_request');
    // var name = document.querySelector('input[type="text"]');
    // var tel = document.querySelector('input[type="number"]');
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

    function check_data(){
        var email_validated = validate_email();
        var name_validated = validate_name();
        var terms_validated = validate_terms();

        if (email_validated && name_validated && terms_validated) {
          $('#register').removeClass('not_continue');
        } else {
          $('#register').addClass('not_continue');
        }
    }


    function validate_email(){
      if ($('#email_check').length) {

        var email = isEmail($('#email_check').val());
        if ($('#email_check').val().length >= 5 && email) {
          $('#email_error').remove();
          return true;
        } else {
          $('#email_error').remove();
          var error_span = '<span class="error-message" id="email_error">Correo invalido</br></br></span>';
          $('#email').append(error_span);
          return false;
        }
      } else {
        return false;
      }
    }

    function validate_name(){
        if ($('#name_check').length) {
          if ($('#name_check').val().length >= 3) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
    }


    function validate_terms(){
        if ($('#checkbox1').is(':checked')){
            return true;
        } else {
            return false;
        }
    }

    function check_data2(){
        var email_validated = validate_email2();
        var name_validated = validate_name2();
        var terms_validated = validate_terms2();

        if (email_validated && name_validated && terms_validated) {
          $('#register2').removeClass('not_continue');
        } else {
          $('#register2').addClass('not_continue');
        }
    }

    function validate_email2(){
        if ($('#email_check2').length) {

          var email = isEmail($('#email_check2').val());
          if ($('#email_check2').val().length >= 5 && email) {
            $('#email_error2').remove();
            return true;
          } else {
            $('#email_error2').remove();
            var error_span = '<span class="error-message" id="email_error2">Correo invalido</br></br></span>';
            $('#email2').append(error_span);
            return false;
          }
        } else {
          return false;
        }
    }

    function validate_name2(){
        if ($('#name_check2').length) {
          if ($('#name_check2').val().length >= 3) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }

    function validate_terms2(){
        if ($('#checkbox2').is(':checked')){
            return true;
        } else {
            return false;
        }

    }

    function isEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }

  });
