// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require select2
//= require_tree .

// Initialize behaviours
function initializeBehaviours() {
  // Init settings

  // from cyt.js
  addAutofocusBehaviour();
  addLinkifyContainersBehaviour();

  // from flash_message
  addFlashMessageBehaviour();

  // from directory_lookup.js
  addDirectoryLookupBehaviour();

  // from nested_form.js
  addNestedFormBehaviour();

  // select2
  $('.select2').select2();

  // application
}

// Loads functions after DOM is ready
$(document).ready(initializeBehaviours);
