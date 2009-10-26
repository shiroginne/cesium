Droppables.activate = Droppables.activate.wrap(function(proceed, drop) {
  if (drop.element.nodeName == 'LI' && drop.element.select('ul').size() == 0) {
    container = new Element('ul')
    drop.element.appendChild(container)
    Droppables.add(container, {
      onHover:      Sortable.onEmptyHover,
      overlap:      'vertical',
      containment:  $('sortable_tree'),
      hoverclass:   ''
    })
  }
  proceed(drop)
})

Sortable.onEmptyHover = Sortable.onEmptyHover.wrap(function(proceed, element, dropon, overlap) {
  $('sortable_tree').select('ul').each(function(ul) {
    if (ul != dropon && ul.empty()) {
      Droppables.remove(ul)
      ul.remove()
    }
  })
  proceed(element, dropon, overlap)
})

Event.observe(window, 'load', function(){
    if ($('notice')) {
        $('notice').fade({ duration: 3.0 });
    }

    if ($('pages_tree')) {
      //$('pages_tree').select('ul')[0].id = 'sortable_tree'
      //Sortable.create('sortable_tree', { tree: true, scroll: window, hoverclass: 'empty', dropOnEmpty: true });
    }

    window.tabs = new CesiumTabs('parts', 'parts_tabs');
});
