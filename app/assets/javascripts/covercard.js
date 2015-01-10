jQuery(document).ready(function(){
  jQuery(document).on('click', '.reset-updated-attribute', function(){
    var link = jQuery(this)
    var value = link.attr('data-value');
    var input = link.prev();

    input.removeClass('attribute-updated').val(value);
    link.css('visibility', 'hidden');
  });
});
