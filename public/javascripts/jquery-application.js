function addDatePickerBehaviour() {
  jQuery('input[id$="_date"], input[id*="_date_"]').each(function(){
    jQuery(this).datepicker({ dateFormat: 'dd.mm.yy' });
  });
};

function initBehaviour() {
  addDatePickerBehaviour();
};

jQuery(document).ready(function($) {
  initBehaviour();
});
