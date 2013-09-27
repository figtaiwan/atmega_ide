// C:\ksanapc\atmega_ide\aura_components\console-out-widget\main.js
define(['text!./template.tmpl','backbone'], 
 function(template,Backbone) {
  return { type:"Backbone",
      ondata:function(data) {
        console.log(JSON.stringify(data))
        $("#consoleOut").append(data)                     // 待改20130926
//      $("#consoleTmp").append(data)                     // 待改20130926
        $body.scrollTop=$body.scrollHeight
        $('#inp_command')[0].focus()
//      this.sandbox.emit("inp_command_focus")
      },
      render:function()  {
          this.html( template);
      },
      initialize: function() {
        $body=$("body")[0]
        this.sandbox.on("data",this.ondata,this)
        this.render()
      }
    }
});
