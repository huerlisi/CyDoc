/*
  Based on code from Redmine <http://www.redmine.org>
  Copyright (C) 2006-2008 Jean-Philippe Lang
  Copyright (C) 2009-2010 Simon Hürlimann (ZytoLabor) <simon.huerlimann@cyt.ch>
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
