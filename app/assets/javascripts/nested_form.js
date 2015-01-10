function addNestedFormBehaviour() {
  $('body').on('click', '.delete-nested-form-item', function(event) {
    var item = $(this).parents('.nested-form-item');
    // Hide item
    item.hide();
    // Mark as ready to delete
    item.find("input[name$='[_destroy]']").val("1");
    item.addClass('delete');
    // Drop input fields to prevent browser validation problems
    item.find(":input").not("[name$='[_destroy]'], [name$='[id]']").remove();

    // Don't follow link
    event.preventDefault();
  });
}
