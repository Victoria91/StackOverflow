# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_answer_form = ->
	$(this).hide()
	answer_id = $(this).data('answerId')
	$("#answer_"+answer_id).show()

hide_answer_form = (e) ->
	e.preventDefault()
	answer_id = $(this).data('answerId')
	$("#answer_" + answer_id).hide()
	$('.editable_answer').show()

show_question_form = (e) ->
	e.preventDefault()
	$("#edit_question_form").show()

$(document).ready ->
	$(".editable_answer").click(show_answer_form)
	$(".alert").click(hide_answer_form)
	$("#edit_question_link").click(show_question_form)