var CesiumTabs = Class.create({
    initialize: function(target, tabs) {
        this.target = $(target);
        this.tabs = $(tabs);
        this.contents = $$('#' + this.target.id + ' > div');
        this.contents.each(function(element){
            this.addTab(element);
        }.bind(this));
        this.setActiveTab(0);
    },

    addTab: function(target) {
        var tab = new Element('li');
        tab.name_span = new Element('span', {className: 'part_name', title: 'Double click to edit'});
        tab.editor = new Element('input').setStyle({display: 'none'});
        tab.remove_btn = new Element('span', {className: 'part_remove'});
        tab.commit_btn = new Element('span', {className: 'part_commit_name'}).setStyle({display: 'none'});
        tab.appendChild(tab.name_span);
        tab.appendChild(tab.editor);
        tab.appendChild(tab.remove_btn);
        tab.appendChild(tab.commit_btn);
        tab.name = target.select('input')[0];
        if (!/\[new_/.test(tab.name.name)) {
            tab.dbid = /[\d]+/.exec(tab.name.id)[0];
        }
        tab.name_span.update($F(tab.name));

        tab.observe('click', function(){
            this.setActiveTab(tab);
        }.bind(this));
        tab.observe('dblclick', function(){
            this.editTabName(tab);
        }.bind(this));
        tab.remove_btn.observe('click', function(event){
            Event.stop(event);
            if (confirm('Are u shure?')) {
                this.removeTab(tab);
            }
        }.bind(this));
        tab.commit_btn.observe('click', function(event){
            Event.stop(event);
            this.commitTabName(tab);
        }.bind(this));
        tab.editor.observe('click', function(event){
            Event.stop(event);
        }.bind(this));
        Event.observe(document, 'click', function(){
            if (this.current_tab) {
                this.cancelTabName(this.current_tab);
            }
        }.bind(this));
        
        tab.target = target;
        this.tabs.appendChild(tab);
        target.hide();
        this.tabs.appendChild(tab);
        this.setActiveTab(tab);
    },

    removeTab: function(tab) {
        if (tab == this.current_tab && this.tabs.childElements().size() != 1) {
            var i = 0;
            var number = 0;
            this.tabs.childElements().each(function(element){
                if (element == tab) {
                    number = i;
                    throw $break;
                }
                i++;
            });
            if (tab == this.tabs.childElements().last()) {
                this.setActiveTab(number - 1);
            } else {
                this.setActiveTab(number + 1);
            }
        }
        if (tab.dbid) {
            this.target.insert({ after: '<input id="page_page_parts_attributes_' + tab.dbid + '__delete" name="page[page_parts_attributes][' + tab.dbid + '][_delete]" type="hidden" value="1" />'});
        }
        tab.target.remove();
        tab.remove();
    },

    editTabName: function(tab) {
        tab.editor.value = tab.name_span.innerHTML;
        tab.editor.show();
        tab.name_span.hide();
        tab.remove_btn.hide();
        tab.commit_btn.show();
    },

    commitTabName: function(tab) {
        tab.name_span.update(tab.editor.value);
        this.cancelTabName(tab);
        tab.name.value = tab.editor.value;
    },

    cancelTabName: function(tab) {
        tab.name_span.show();
        tab.editor.hide();
        tab.commit_btn.hide();
        tab.remove_btn.show();
    },

    setActiveTab: function(tab) {
        if (this.current_tab) {
            this.current_tab.removeClassName('selected');
            this.current_tab.target.hide();
        }
        
        if (Object.isNumber(tab)) {
            this.current_tab = this.tabs.childElements()[tab]
        } else {
            this.current_tab = tab
        }
        if (this.current_tab) {
            this.current_tab.addClassName('selected');
            this.current_tab.target.show();
        }
    }
});
