function showPrintingFlash(document_type, count) {
    var flash_id = 'notice_flash';

    if (count === undefined || count < 2) {
        text = document_type + ' wird zum Druck aufbereitet...';
    } else {
        text = document_type + ' werden zum Druck aufbereitet...';
    }
  
    Element.update(flash_id, text);
    Element.show(flash_id);
    Element.hide('error_flash');
}
