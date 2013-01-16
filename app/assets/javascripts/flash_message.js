function addFlashMessageBehaviour() {
  $('.alert-success').delay(2500).slideUp();
}

function showFlashMessage(message) {
  $('#main').prepend(message);
  addFlashMessageBehaviour();
}
