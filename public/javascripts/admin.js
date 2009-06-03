Event.observe(window, 'load', function(){
    if ($('notice')) {
        $('notice').fade({ duration: 3.0 });
    }
    //Sortable.create('pages_tree', { tree: true, scroll: window, hoverclass: 'empty'});
});

var expand_list = function(id) {
    new Ajax.Updater('page_' + id + '_sub', '/admin/pages/' + id, {
        asynchronous: true,
        evalScripts: true,
        method: 'get',
        onComplete: function() {
            make_expanded(id)
        }
    });
}

var collapse_list = function(id) {
    $('page_' + id + '_sub').update();
    make_collapsed(id);
}

var make_expanded = function(id) {
    element = $('page_' + id + '_toggle');
    element.update('-');
    element.onclick = function() {
        collapse_list(id);
        return false;
    };
}

var make_collapsed = function(id) {
    element = $('page_' + id + '_toggle');
    element.update('+');
    element.onclick = function() {
        expand_list(id);
        return false;
    };
}