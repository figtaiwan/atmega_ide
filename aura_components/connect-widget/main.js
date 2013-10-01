// C:\ksanapc\atmega_ide\aura_components\connect-widgit\main.js
define(['underscore','text!./template.tmpl','text!../config.json','../lib.js'],
  function(_,template,config,lib) {
  // 參照 C:\ksanapc\atmega_ide\config.json 設定 port 與 baudrate
  return { type:"Backbone",
    tryopen:function() { // 試連 serial port
        var that=this
        that.serialport.open(function(data) {
            that.sandbox.emit("trying")
            if (typeof data !='undefined') {
                that.sandbox.emit("openfail")
                return
            }
            that.active=true
            clearInterval(that.timer)
            setTimeout(function(){
                that.ok=new Buffer(0)
                that.serialport.write('\r') // 自動
            },5000)
            that.sandbox.emit("connected")
            that.serialport.on("data", function (data) {
                // 2. 收 serial port data 至 consoleOut
                that.data=Buffer.concat([that.data,data],[2])   // 20130926
                var td=that.data.toString().replace(/</g,'&lt;')// 20130926
                var tc=that.command
                var to=that.ok
                if (to && (!to.length || to[to.length-1]!==6))
                    to=that.ok=Buffer.concat([that.ok,data],[2])
                if (to&&to.length&&to[to.length-1]===6) {
                    var tt=to.toString()
                    var i=td.length-tt.length
                    if (td.substr(i)===tt) {
                        td=td.substr(0,i)+'<font color=green>'+tt+'</font>'
                    }
                }
                if (td.indexOf(tc)===0) {
                    td='<font color=blue>'+tc+'</font>'
                        +td.substr(tc.length)
                }
                that.tmp.html(td)                       // 20130926
                that.sendCommand()
            })
            that.serialport.on("close", function () {
                that.active=false;
                that.sandbox.emit("close")
                that.timer=setInterval( function(){ that.tryopen()} , 1000);
            })
            that.serialport.on("error",function(err) { 
                if (!that.active) return
                that.sandbox.emit("error")
            })
            that.sandbox.on("command",function(cmd){
                // 寫 command 到 serial port
                that.commands.push(cmd)
                that.sendCommand()
            })
            that.sandbox.on("file",function(filename){
                // 傳 file 到 serial port
                var path=that.config.system+'\\'+filename
                var lines=that.fs.readFileSync(path).toString().split(/\n/)
                // 注意!! eforth 一直等到每 line 最後的 \r 才處理
                that.commands=that.commands.concat(lines)
                that.sendCommand()
            })
        })
    },
    sendCommand: function() {
        var tc=this.commands, td=this.data
        if ( tc.length===1 ) {
            console.log('最後一列')
        }
        if (   tc.length
            && tc[tc.length-1].charCodeAt(0)===27
        ) {
            this.serialport.write(tc[tc.length-1])
            this.commands=[]
            this.sandbox.emit("data",this.tmp.html())
            this.data=new Buffer(0) 
        } else if (
               tc.length            // 指令 array 長度非 0
            && td[td.length-1]===6  // 資訊結束 等候指令
        ) {
            var cmd=tc.shift()      // 依序 逐列 取出 指令
            var i=lib.cutLength(cmd)
            if (i<cmd.length) {
                cmd='<font color=red>輸入列不能太長</font>\r\n'
                    +cmd.substr(0,i)
                    +'<font color=red>'
                    +cmd.substr(i)
                    +'</font>'
                this.sandbox.emit("data",cmd+'\r\n')
                this.commands=[]
            } else if (cmd) {
                this.serialport.write(cmd)
                // 刪掉 cmd 列尾的 \r 並替換 小於符號 為 &lt;
                this.command=cmd.substr(0,cmd.length-1).replace(/</g,'&lt;')
                this.sandbox.emit("data",this.tmp.html())
                this.data=new Buffer(0)
            }
        }
    },
    render:function() {
        this.$el.html( _.template(template,this.config) );
    },
    initialize:function() {
    // 啟動程序
        var S=require('serialport') // 注意!!! 這 serialport 元件 not portable
        var that=this
        that.fs=require('fs')
        that.data= new Buffer(0)
        that.tmp=$('#consoleTmp')
        that.commands=[]
        that.config=JSON.parse(config) // 預設 config.json
        that.active=false 
        that.serialport= new S.SerialPort(
            that.config.port,
            {baudrate:that.config.baudrate},false
        )
        // 嘗試每秒與 serial port 連線
        that.timer=setInterval(function(){that.tryopen()}, 1000)
        that.render()
    }

}});