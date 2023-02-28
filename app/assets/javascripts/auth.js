/************SIGN IN FORM VALIDATION***********/
  (function() {
    'use strict';
    window.addEventListener('load', function() {
      // Fetch all the forms we want to apply custom Bootstrap validation styles to
      var forms = document.getElementsByClassName('new_user');
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
  
    /**********VALIDATE CHANGE PASSWORD ON RESET PWD FORM*****************/
    $('#rst_verify_pass input, #rst_verify_pass_confirm input').on("keyup blur", function(){
      check_pwd();
    });
  
    function check_pwd(){
      var password_validated = validate_password();
      var password_confirmation_validated = validate_password_confirmation();
  
      if (password_validated && password_confirmation_validated) {
        $('#reset_pwd').removeClass('not_continue');
      } else {
        $('#reset_pwd').addClass('not_continue');
      }
    }
  
    function validate_password(){
      if ($("#user_password").length){
        var nitRegExp = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{1,70}$');
        var user_password = $('#user_password').val();
        if (nitRegExp.test(user_password) && $('#user_password').val().length >= 8) {
          $('#rst_verify_pass input').addClass("valid");
          $('#rst_verify_pass input').removeClass("invalid");
          $('#rst_verify_pass .invalid-feedback').css("display", "none");
          return true;
        } else {
          $('#rst_verify_pass input').addClass("invalid");
          $('#rst_verify_pass input').removeClass("valid");
          $('#rst_verify_pass .invalid-feedback').css("display", "block");
          return false;
        }
      } else {
        return false;
      }
    }
  
    function validate_password_confirmation(){
      if ($('#user_password_confirmation').length) {
        var password = $('#user_password').val();
        var password_confirmation = $('#user_password_confirmation').val();
        if (password_confirmation == password) {
          $('#rst_verify_pass_confirm input').addClass("valid");
          $('#rst_verify_pass_confirm input').removeClass("invalid");
          $('#rst_verify_pass_confirm .invalid-feedback').css("display", "none");
          return true;
        } else {
          $('#rst_verify_pass_confirm input').addClass("invalid");
          $('#rst_verify_pass_confirm input').removeClass("valid");
          $('#rst_verify_pass_confirm .invalid-feedback').css("display", "block");
          return false;
        }
      } else {
        return false;
      }
    }  
  });
  
