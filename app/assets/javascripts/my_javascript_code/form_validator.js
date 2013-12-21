//alert ("does it work?")

$( document ).ready(function() {


jQuery.validator.setDefaults({
 // debug: true,
 // success: "valid"
});
$( "#signin-form" ).validate({
  rules: {
    email: {
        required: true,
        email: true
    },
    password: {
        required: true,
        minlength: 6
    }

  },

  highlight: function(element) {
    $(element).closest('div.form-group').removeClass('has-success').addClass('has-error');
  },

  unhighlight: function(element) {
    $(element).closest('div.form-group').removeClass('has-error').addClass('has-success');
  }

});

$( "#password-reset-form" ).validate({
  rules: {
    email: {
        required: true,
        email: true
    },

  },

  highlight: function(element) {
    $(element).closest('#form-control').removeClass('has-success').addClass('has-error');
  },

  unhighlight: function(element) {
    $(element).closest('#form-control').removeClass('has-error').addClass('has-success');
  }

});

  //  $( "div.alert.alert-danger.alert-dismissable.fade.in" ).fadeOut( 7500 );

}); // End of document ready