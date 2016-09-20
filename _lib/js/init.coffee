# Move objects by a rate, when scrolling
# positive rate speeds up, negative rate slows down
paralax = (target, rate)->
	move = window.scrollY*rate
	target.style.transform = "translateY(#{-move}px)"

trap = (target, trap, bottom=true, top=true, bxtra=0, txtra=0)->
	if bottom
		bottomStretch = (trap.offsetTop + trap.offsetHeight) - (window.scrollY + window.innerHeight) + bxtra
	else bottomStretch = 0

	if top
		topStretch = (trap.offsetTop + target.offsetHeight) - (window.scrollY + window.innerHeight) + txtra
	else topStretch = 0

	if topStretch > 0
		target.style.transform = "translateY(#{topStretch}px)"
	else if bottomStretch < 0
		target.style.transform = "translateY(#{bottomStretch}px)"
	else target.style.transform = "translateY(0px)"
