/*!
 * froala_editor v3.2.2 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2020 Froala Labs
 */


!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?t(require("froala-editor")):"function"==typeof define&&define.amd?define(["froala-editor"],t):t(e.FroalaEditor)}(this,function(e){"use strict";e=e&&e.hasOwnProperty("default")?e["default"]:e,Object.assign(e.DEFAULTS,{html2pdf:window.html2pdf}),e.PLUGINS.print=function(a){return{run:function e(){!function l(e){var t=a.html.get(),n=null;a.shared.print_iframe?n=a.shared.print_iframe:((n=document.createElement("iframe")).name="fr-print",n.style.position="fixed",n.style.top="0",n.style.left="-9999px",n.style.height="100%",n.style.width="0",n.style.overflow="hidden",n.style["z-index"]="2147483647",n.style.tabIndex="-1",a.events.on("shared.destroy",function(){n.remove()}),a.shared.print_iframe=n);try{document.body.removeChild(n)}catch(d){}document.body.appendChild(n);var i=function i(){e(),n.removeEventListener("load",i)};n.addEventListener("load",i);var o=n.contentWindow;o.document.open(),o.document.write("<!DOCTYPE html><html "+(a.opts.documentReady?'style="margin: 0; padding: 0;"':"")+"><head><title>"+document.title+"</title>"),Array.prototype.forEach.call(document.querySelectorAll("style"),function(e){e=e.cloneNode(!0),o.document.write(e.outerHTML)});var r=document.querySelectorAll("link[rel=stylesheet]");Array.prototype.forEach.call(r,function(e){var t=document.createElement("link");t.rel=e.rel,t.href=e.href,t.media="print",t.type="text/css",t.media="all",o.document.write(t.outerHTML)}),o.document.write('</head><body style="height:auto;text-align: '+("rtl"==a.opts.direction?"right":"left")+"; direction: "+a.opts.direction+"; "+(a.opts.documentReady?" padding: 2cm; width: 17cm; margin: 0;":"")+'"><div class="fr-view">'),o.document.write(t),o.document.write("</div></body></html>"),o.document.close()}(function(){setTimeout(function(){a.events.disableBlur(),window.frames["fr-print"].focus(),window.frames["fr-print"].print(),a.$win.get(0).focus(),a.events.disableBlur(),a.events.focus()},0)})},toPDF:function t(){a.opts.html2pdf&&(a.$el.css("text-align","left"),a.opts.html2pdf().set({margin:[10,20],html2canvas:{useCORS:!0}}).from(a.el).save(),setTimeout(function(){a.$el.css("text-align","")},100))}}},e.DefineIcon("print",{NAME:"print",SVG_KEY:"print"}),e.RegisterCommand("print",{title:"Print",undo:!1,focus:!1,plugin:"print",callback:function(){this.print.run()}}),e.DefineIcon("getPDF",{NAME:"file-pdf-o",FA5NAME:"file-pdf",SVG_KEY:"pdfExport"}),e.RegisterCommand("getPDF",{title:"Download PDF",type:"button",focus:!1,undo:!1,callback:function(){this.print.toPDF()}})});