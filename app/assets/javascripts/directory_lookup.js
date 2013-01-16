function showDirectoryLookupDialog(selector) {
  var params = $("[name^='" + selector + "']").not("[name$='[id]']").serialize();
  var selector_param = $.param({selector: selector});

  var query = '/directory_lookup/search?' + params + '&' + selector_param;
  $.getScript(query);
}

function updateFromDirectoryLookup(selector, params) {
  ['family_name', 'given_name'].map(function(attribute) {
    $("input[name^='" + selector + "[" + attribute + "]']").val(params[attribute]);
  });

  ['street_address', 'locality', 'postal_code'].map(function(attribute) {
    $("input[name^='" + selector + "[address_attributes][" + attribute + "]']").val(params[attribute]);
  });
}

function directoryLookupHandler() {
  var selector = $(this).data('directory-lookup-selector');
  var params = $(this).data('directory-lookup-attributes');

  updateFromDirectoryLookup(selector, params);

  $('#directory_lookup').modal('hide');
}


function addDirectoryLookupBehaviour() {
  $('body').on('click', '[data-directory-lookup]', function(e) {
    var selector = $(this).data('directory-lookup');
    showDirectoryLookupDialog(selector);

    e.preventDefault();
  })

  $('body').on('click', '[data-directory-lookup-attributes]', directoryLookupHandler);
}
