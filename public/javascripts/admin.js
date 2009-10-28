function createEmptyContainer(where) {
  if (where.nodeName == 'LI' && where.select('ul').size() == 0) {
    container = new Element('ul');
    where.appendChild(container);
    Droppables.add(container, {
      onHover:      Sortable.onEmptyHover,
      tree:         true,
      overlap:      'vertical',
      containment:  $('sortable_tree'),
      hoverclass:   'empty'
    });
  }
}

function clearEmptyContainers(except) {
  $('sortable_tree').select('ul').each(function(ul) {
    if (ul != except && ul.empty()) {
      Droppables.remove(ul);
      ul.remove();
    }
  })
}

function getId(from) {
  return from.gsub(/^page_/, '');
}

Draggables.activate = Draggables.activate.wrap(function(proceed, draggable) {
  proceed(draggable);
  Draggables.dragged_element = draggable.element;
});

Draggables.deactivate = Draggables.deactivate.wrap(function(proceed, draggable) {
  proceed(draggable);
  clearEmptyContainers();
});

Sortable.onHover = Sortable.onHover.wrap(function(proceed, element, dropon, overlap) {
  createEmptyContainer(dropon);
  proceed(element, dropon, overlap);
});

Sortable.onEmptyHover = Sortable.onEmptyHover.wrap(function(proceed, element, dropon, overlap) {
  clearEmptyContainers(dropon);
  proceed(element, dropon, overlap);
});

Event.observe(window, 'load', function(){
    if ($('notice')) {
        $('notice').fade({ duration: 3.0 });
    }

    if ($('pages_tree')) {
      $('pages_tree').select('ul')[0].id = 'sortable_tree'
      Sortable.create('sortable_tree', {tree: true, scroll: window, hoverclass: 'empty', handle: 'handle', onUpdate: function(element) {
        elem = Draggables.dragged_element
        url = '/admin/pages/' + getId(elem.id) + '/move';
        if (elem.previous('li')) {
          url += '?where=' + getId(elem.previous('li').id) + '&mode=right';
        } else if (elem.next('li')) {
          url += '?where=' + getId(elem.next('li').id) + '&mode=left';
        } else {
          url += '?where=' + getId(elem.up('li').id);
        }
        new Ajax.Request(url, {
          asynchronous: true,
          evalScripts: true,
          method: 'get',
        });
      }});
    }

    if ($('parts')) {
      window.tabs = new CesiumTabs('parts', 'parts_tabs');
    }
});
