# prototype a method to a string that escapes special chars

String::escapeSpecials = ->
	@
	.replace(/\n/g, "\\\\n")
	.replace(/\r/g, "\\\\r")
	.replace(/\t/g, "\\\\t")
