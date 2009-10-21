Event.observe(window, 'load', function(){
    if ($('notice')) {
        $('notice').fade({ duration: 3.0 });
    }

    if ($('pages_tree')) {
      $('pages_tree').select('ul')[0].id = 'sortable_tree'
      Sortable.create('sortable_tree', { tree: true, scroll: window, hoverclass: 'empty' });
    }

    //$$('#sortable_tree div.info').each(function(info) {
      //info.observe('mouseover', function(event) {
        //li = $(this.parentNode);
        //if (Draggables.activeDraggable && Draggables.activeDraggable.element != li) {
          //console.log(Draggables.activeDraggable)
          //console.log(li)
        //}
      //}.bind(info));
    //});

    //Event.observe('sortable_tree', "mouseover", function(event) {
      //if (event.target.className == 'info') {
        //li = $(event.target.parentNode);
        //console.log(li)
      //}
    //});


    window.tabs = new CesiumTabs('parts', 'parts_tabs');
});
