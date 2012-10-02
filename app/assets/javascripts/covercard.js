jQuery(document).ready(function(){
  jQuery('.reset-updated-attribute').live('click', function(){
    var link = jQuery(this)
    var value = link.attr('data-value');
    var input = link.prev();

    input.removeClass('attribute-updated').val(value);
    link.css('visibility', 'hidden');
  });
});
