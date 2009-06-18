/*
  From redMine - project management software
  Copyright (C) 2006-2008  Jean-Philippe Lang
*/

function showTab(name) {
    var f = $$('div#content .tab-content');
        for(var i=0; i<f.length; i++){
                Element.hide(f[i]);
        }
    var f = $$('td.tabs a');
        for(var i=0; i<f.length; i++){
                Element.removeClassName(f[i], "selected");
        }
        Element.show('tab-content-' + name);
        Element.addClassName('tab-' + name, "selected");
        return false;
}

function showSubTab(name) {
    var f = $$('div#content .sub-tab-content');
        for(var i=0; i<f.length; i++){
                Element.hide(f[i]);
        }
    var f = $$('.sub-tabs a');
        for(var i=0; i<f.length; i++){
                Element.removeClassName(f[i], "selected");
        }
        Element.show('sub-tab-content-' + name);
        Element.addClassName('sub-tab-' + name, "selected");
        return false;
}
