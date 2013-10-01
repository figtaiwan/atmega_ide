// C:\ksanapc\atmega_ide\aura_components\console-in-widget\main.js
define(['text!./template.tmpl','text!../config.json','backbone'], 
 function(template,config,Backbone) {
  return { type:"Backbone",
      render:function() {
        this.html(_.template(template,{}));
      },
      events: {
        "change #inp_command":"command_change",
        "keydown #inp_command":"command_keydown",
        "keypress #inp_command":"command_keypress",
        "keyup #inp_command":"command_keyup",
        "click #btn_sendcommand":"commandsend_click",
        "keydown #inp_filename":"filename_keydown",
        "click #btn_transferfile":"filetransfer_click"
      },
      command_change:function() {
        var $cmd=this.$el.find("#inp_command")
        var $len=this.$el.find("#command_len")
        var n=0,t=$cmd.val()
        for(var i=0;i<t.length;i++)n+=t.charCodeAt(i)>256?3:1
        $len.html(n)
      },
      command_keydown:function(e) {
        var k=e.keyCode
        if (k==13) {
          this.commandsend_click()
        } else if (k==27) {
          $cmd=this.$el.find('#inp_command')
          $cmd.val('')
          this.sandbox.emit("command",String.fromCharCode(e.keyCode))
        }
      },
      command_keypress:function(e) {
        var k=e.keyCode
        if (k==26||k==17) {
          this.sandbox.emit("command",String.fromCharCode(e.keyCode))
        }
      },
      command_up:function(e) {
        var k=e.keyCode
        if (k>31||k===8) {
          var $cmd=this.$el.find("#inp_command")
          var $len=this.$el.find("#command_len")
          var n=0,t=$cmd.val()
          for(var i=0;i<t.length;i++)n+=t.charCodeAt(i)>256?3:1
          $len.html(n)
        }
      },
      commandsend_click:function() {
        $cmd=this.$el.find('#inp_command')
        var cmd=$cmd.val()
        $cmd.val('')
        this.sandbox.emit("command",cmd+"\r")
      },
      filename_keydown:function() {
        if (e.keyCode==13) {
          this.filetransfer_click()
        }
      },
      filetransfer_click:function(e) {
        var filename=this.$el.find("#inp_filename").val()
        this.sandbox.emit("file",filename)
      },
      initialize: function() {
        this.fs=require('fs')
        this.render()
      }
    }
});
