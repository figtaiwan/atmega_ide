define([], function() {
return {
	cutLength: function(cmd) { var n=0
		for (var i=0; i<cmd.length; i++) {
			n+=cmd.charCodeAt(i)>127?3:1
			if (n>79) break
		}
		return i
	}
}})