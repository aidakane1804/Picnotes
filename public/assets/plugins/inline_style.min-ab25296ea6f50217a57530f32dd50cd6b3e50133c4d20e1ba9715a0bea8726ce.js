/*!
 * froala_editor v3.2.2 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2020 Froala Labs
 */


!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?t(require("froala-editor")):"function"==typeof define&&define.amd?define(["froala-editor"],t):t(e.FroalaEditor)}(this,function(e){"use strict";e=e&&e.hasOwnProperty("default")?e["default"]:e,Object.assign(e.DEFAULTS,{inlineStyles:{"Big Red":"font-size: 20px; color: red;","Small Blue":"font-size: 14px; color: blue;"}}),e.PLUGINS.inlineStyle=function(i){return{apply:function a(e){for(var t=e.split(";"),n=0;n<t.length;n++){var l=t[n].split(":");t[n].length&&2==l.length&&i.format.applyStyle(l[0].trim(),l[1].trim())}}}},e.RegisterCommand("inlineStyle",{type:"dropdown",html:function(){var e='<ul class="fr-dropdown-list" role="presentation">',t=this.opts.inlineStyles;for(var n in t)if(t.hasOwnProperty(n)){var l=t[n]+(-1===t[n].indexOf("display:block;")?" display:block;":"");e+='<li role="presentation"><span style="'.concat(l,'" role="presentation"><a class="fr-command" tabIndex="-1" role="option" data-cmd="inlineStyle" data-param1="').concat(t[n],'" title="').concat(this.language.translate(n),'">').concat(this.language.translate(n),"</a></span></li>")}return e+="</ul>"},title:"Inline Style",callback:function(e,t){this.inlineStyle.apply(t)},plugin:"inlineStyle"}),e.DefineIcon("inlineStyle",{NAME:"paint-brush",SVG_KEY:"inlineStyle"})});
