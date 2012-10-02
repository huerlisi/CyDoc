// Combobox
function addComboboxBehaviour() {
  jQuery("select.combobox").combobox();
}

// Autofocus element having attribute data-autofocus
function addAutofocusBehaviour() {
  jQuery('*[data-autofocus=true]')
    .filter(function() {return jQuery(this).parents('.form-view').length < 1})
    .first().focus();
};

// Add datepicker
function addDatePickerBehaviour() {
  jQuery('*[date-picker=true]').each(function(){
    jQuery(this).datepicker({ dateFormat: 'dd.mm.yy' });
  });
};

//
function addSortableBehaviour() {
  jQuery(".sortable").sortable({
    placeholder: 'ui-state-highlight'
  });
  jQuery(".sortable").disableSelection();
};


// Linkify containers having attribute data-href-container
function addLinkifyContainersBehaviour() {
  var elements = jQuery('*[data-href-container]');
  elements.each(function() {
    var element = jQuery(this);
    var container = element.closest(element.data('href-container'));
    container.css('cursor', "pointer");
    container.addClass('linkified_container')
    var href = element.attr('href');
    element.addClass('linkified_element')

    container.delegate('*', 'click', {href: href}, function(event) {
      // Don't override original link behaviour
      if (event.target.nodeName != 'A' && jQuery(event.target).parents('a').length == 0) {
        document.location.href = href;
      };
    });
  });
};

// Autogrow
function addAutogrowBehaviour() {
  jQuery(".autogrow").elastic();
};

// Add tooltips for overview
function addTooltipBehaviour() {
  jQuery(".tooltip-title[title]").each(function() {
    if ( jQuery(this).attr('title') != '' ) {
      jQuery(this).tooltip({
        position: 'top center',
        predelay: 500,
        effect: 'fade'
      });
    }
  });
};

// Add tooltips for overview
function addOverviewTooltipBehaviour() {
  jQuery('.overview-list li a[title]').tooltip({
    position: 'center right',
    predelay: 500,
    effect: 'fade'
  });
};

// Add icon action tooltips
function addIconTooltipBehaviour() {
  jQuery('a.icon-tooltip[title]').tooltip({
    tipClass: 'icon-tooltip-popup',
    effect: 'fade',
    fadeOutSpeed: 100
  });
};

function addTimeCheckBehaviour() {
  jQuery('*[data-check-hours=true]').setMask();
}
