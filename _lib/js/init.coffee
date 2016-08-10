$(document).on 'scroll', ->
	$('#main-menu').trap()
	return

$(document).on 'click', 'a[href^="#"]', ->
	$('html, body').animate { scrollTop: $($(this).attr('href')).offset().top - 100 }, 500
	return
