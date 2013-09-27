define(['underscore','text!./template.tmpl','backbone'], 
 function(_,template,Backbone) {
  return { type:"Backbone",
      // A. 設 hello 為 按鈕 btnhello 的處理程序
      // (按鈕 id='btnhello' 定義於 template.tmpl)
      events: {
        "click #btnhello":"hello"
      },
      close:function() {
          this.model.set("connected",false);
      },
      connected:function() {
          this.model.set("connected",true);
          this.$el.find("#trying").fadeOut(1000);
      },
      onerror:function() {
          //this.model.set("errormessage",true);
      },   
      ondata:function(data) {
//      console.log(data.toString())
//      this.$el.find("#consoleOut").append(data.toString())
          //this.model.set("errormessage",true);
      }, 
      trying:function() {
          this.$el.find("#trying").show().fadeOut(1000);
      },
      render:function() {
        var obj=this.model.toJSON();
        this.$el.html( _.template(template,obj) );
      },
      model:new Backbone.Model({port:'com5',baud:19200,connected:false}),
/*    onkeydown:function(e) {
        if (e.keycode=13) {
          this.sandbox.emit("consoleIn",this.$el.find("#consoleIn").val())
        }
      },
*/    // C. 啟動 網頁畫面
      initialize: function() {
        // B. 套 template.tmpl 設定 my-widget 對應的 innerHTML
        this.model.on("change",this.render,this);
        this.sandbox.on("connected",this.connected,this)
        this.sandbox.on("data",this.ondata,this)
        this.sandbox.on("close",this.close,this)
        this.sandbox.on("error",this.onerror,this)
        this.sandbox.on("trying",this.trying,this)
        this.render()
//        this.$el.find("#consoleIn").bind(this.onkeydown)
      }
    }
});
