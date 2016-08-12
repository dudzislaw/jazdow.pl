# prototype a method to a string that escapes special chars

String::escapeSpecials = ->
	@
	.replace(/\n/g, "\\\\n")
	.replace(/\r/g, "\\\\r")
	.replace(/\t/g, "\\\\t")


# Move objects by a rate, when scrolling
# positive rate speeds up, negative rate slows down
paralax = (target, rate)->
	move = $(document).scrollTop()*rate
	target.css "transform":"translateY(#{-move}px)"


$.fn.extend(
	# If TARGET element has a position:fixed, you can trap it between the CEILING and the FLOOR elements
	trap: (ceil = {selector:'body', edge:'top'}, floor = {selector:'body', edge:'bottom'}, windowTrap = true)->
		#	ceil: <object> or <string>
		# 		selector <string> 				– selector for the ceil element
		#		edge <'top'> or <'bottom'> 		– whether the top or the bottom edge should become a trap
		#	floor: <object> or <string>
		# 		selector <string> 				– selector for the ceil element
		#		edge <'top'> or <'bottom'> 		– whether the top or the bottom edge should become a trap
		#	windowTrap: <boolean> 				– whether use window as a trap or not

		if this.css('position') is 'fixed'
			this.css "transform":"translateY(0px)"
			return
		# if the element position is fixed then fuck it. traping should not kick in. Also reset translateY to 0

		if windowTrap
			offsetTop = $(document).scrollTop() - this[0].offsetTop
			offsetBottom = $(document).scrollTop() + window.innerHeight - this[0].offsetTop - this[0].offsetHeight

			if offsetTop >= 0
				this.css "transform":"translateY(#{offsetTop}px)"
				this.addClass('trapped top').removeClass('bottom')
			else if offsetBottom <= 0
				this.css "transform":"translateY(#{offsetBottom}px)"
				this.addClass('trapped bottom').removeClass('top')
			else
				this.css "transform":"translateY(0px)"
				this.removeClass('trapped top bottom')
			return
		# if windowTrap then fuck other options, trap in window and return

		ceilObj = if typeof ceil is 'string' then $(ceil) else $(ceil.selector)
		floorObj = if typeof floor is 'string' then $(floor) else $(floor.selector)

		# Calculate CEIL trap point
		this.ceilTrap = false
		if ceilObj.length isnt 0
			switch ceil.edge
				when 'top' then this.ceilTrap = ceilObj.offset().top
				else this.ceilTrap = ceilObj.offset().top + ceilObj.outerHeight()

		# Calculate FLOOR trap point
		this.floorTrap = false
		if floorObj.length isnt 0
			switch floor.edge
				when 'bottom' then this.floorTrap = floorObj.offset().top + floorObj.outerHeight()
				else this.floorTrap = floorObj.offset().top

		# Check if CEIL or FLOOR trapping should kick in
		isTrapCeil = this.ceilTrap > $(document).scrollTop() + $(window).height() - this.outerHeight()
		isTrapFloor = this.floorTrap < ($(document).scrollTop() + $(window).height())

		offset = 0

		if this.ceilTrap and isTrapCeil
			offset = this.ceilTrap + this.outerHeight() - $(document).scrollTop() - $(window).height()
		if this.floorTrap and isTrapFloor
			offset = this.floorTrap - $(document).scrollTop() - $(window).height()

		this.css "transform":"translateY(#{offset}px)"

		return

)
