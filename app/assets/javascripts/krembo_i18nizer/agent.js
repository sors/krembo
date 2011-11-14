if (typeof(jQuery)=='undefined'){
  var script = document.createElement("script");
  script.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js";
  script.onload = script.onreadystatechange = function(){
    // I18nT.init(jQuery);
  };
  document.body.appendChild( script );

}
jQuery(document).ready(function(jQuery) {
  I18nT.init(jQuery);
})

I18nT =
  {
  active:false,
  init:function(jQuery) {
    this.addGUI();
    this.parseAllAttributes();
    this.parseAllTextElements();
    this.bindClick();
    I18nT.jQuery = this.$ = jQuery;
    this.$('body').css('visibility','visible')
  },
  addGUI:function() {
    document.documentElement.innerHTML += '<div class="i18nControlPannel"><button id="i18nToggle">Toggle edit inline</button>'; //<button id="i18nToggleForm">Toggle edit form</button> </div>
  },
  parseAllAttributes:function() {
    var matches = document.documentElement.innerHTML.match(/<[^<]*[",'](\{\%[^\}]*\%\})[",'].*>/gi);
    if (!matches) return;
    for (var i = 0; i < matches.length; i++) {
      var match = matches[i];
      var html = match.replace(/(\{\%[^\}]*\%\})/gi,'')
      document.documentElement.innerHTML = document.documentElement.innerHTML.replace(match, html)
}
    },
    parseAllTextElements:function() {
      var matches = document.documentElement.innerHTML.match(/(\{\%.*\%\})/gi)
      if (!matches) return;
      for (var i = 0; i < matches.length; i++) {
        var match = matches[i];
        var obj = this.parse(match);
        var html = this.decorateTextElement(obj);
        document.documentElement.innerHTML = document.documentElement.innerHTML.replace(match, html)
      }
    },
    parse:function(match) {
      console.log(match)
      var obj = match.replace(/{%/g,'{').replace(/%}/g,'}'); 
      if (obj.indexOf('class="translation_missing"') >= 0) {
        obj = obj.replace(/'value':'.*'/i, "'value':''")
      }

      obj = obj.replace(/'/g, '"');
      if (obj.indexOf('"value":"{')>-1){
        obj = obj.replace(/"value".*/i,'"value":""}');
      }

      obj = JSON.parse(obj);
      if (obj['KEY']){ obj.key = obj.KEY.toLowerCase() }
      if (obj['VALUE']){ obj.value = obj.VALUE }
      if (obj.value==''){ obj.value = obj.key}
      return obj;
    },

    decorateTextElement:function(obj) {
      var html = '<span data-i18n="' + obj.key + '" class="i18nized">' + obj.value + '</span>';
      return html;
    },

    bindClick:function() {

      jQuery("#i18nToggle").click(function() {
        if (I18nT.active) {
          jQuery(".i18nized").removeClass("i18nized-active");
        }else{
          jQuery(".i18nized").addClass("i18nized-active");
        }
        I18nT.active = !I18nT.active;
      })
      jQuery(".i18nInput").live("blur",function(){
        endEditField(this)
      });
      jQuery(".i18nInput").live("keydown",function(e){
        if (e.keyCode==13){
          this.blur()
        }
      }) ;
      function endEditField(field){
        var val = jQuery(field).val();
        var key = jQuery(field).data('key')
        jQuery(field).parent().data("active",'false')
        jQuery(field).parent().html(jQuery(field).val())
        jQuery.get('/krembo_i18nizer/translator/update?key='+escape(key)+'&value='+escape(val));
      }
      jQuery(".i18nized").click(function(e) {
        if (!I18nT.active) {return;}
        e.preventDefault();
        if (jQuery(this).data("active")=="true") {return;}
        jQuery(this).data("active","true")
        var key = jQuery(this).data("i18n");
        var value = jQuery(this).text();
        jQuery(this).html('<input type="text" class="i18nInput" data-key="'+key+'" value="'+value+'" style="width:'+jQuery(this).width()+'px"/>');


      })
    }


}

