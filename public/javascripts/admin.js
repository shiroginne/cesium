Event.observe(window, 'load', function(){
    if ($('notice')) {
        $('notice').fade({ duration: 3.0 });
    }
    //Sortable.create('pages_tree', { tree: true, scroll: window, hoverclass: 'empty'});
    window.tabs = new CesiumTabs('parts', 'parts_tabs');
});