function addDatePickerBehaviour() {
  jQuery('input[date-picker ="true"]').each(function(){
    jQuery(this).datepicker({ dateFormat: 'dd.mm.yy' });
  });
};

function initBehaviour() {
  addDatePickerBehaviour();
};

jQuery(document).ready(function($) {
  initBehaviour();
});
