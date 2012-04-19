function showFlashMessage(type, message) {
  // Hide all flash messages
  jQuery('.flash').hide();

  var flash = jQuery('.flash.' + type);
  flash.html(message);
  flash.show();
}
