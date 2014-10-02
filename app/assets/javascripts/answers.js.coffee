# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
	$(document).on 'click', '.editable_answer', (e) ->
		$(this).hide()
		answer_id = $(this).data('answerId')
		$("#answer_"+answer_id).show()

	$(document).on 'click', '.alert', (e) ->
		e.preventDefault()
		answer_id = $(this).data('answerId')
		$("#answer_" + answer_id).hide()
		$('.editable_answer').show()

	$(document).on 'click', '#edit_question_link', (e) ->
		e.preventDefault()
		$("#edit_question_form").show()

$(document).ready(ready)
$(document).on('page:load',ready)