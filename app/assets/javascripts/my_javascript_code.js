//alert ("does it work?")

$( document ).ready(function() {


  Query.validator.setDefaults({
  // debug: true,
  // success: "valid"
  );
  ( "#signin-form" ).validate({
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

  );

  //  $( "div.alert.alert-danger.alert-dismissable.fade.in" ).fadeOut( 7500 );

}); // End of document ready

navigator.geolocation.getCurrentPosition(
      function(position) {
        alert("You were last spotted at (" + position.coords.latitude +
        "," + position.coords.longitude + ")");
} );  // End of get current position