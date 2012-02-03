document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/loading.gif'

    function createSpinner() {
      Element.show('spinner')
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        createSpinner()
        new Ajax.Request(el.href, { method: 'get', onSuccess:function(request){Element.hide('spinner') }})
        e.stop()
      }
    })
  }
})
