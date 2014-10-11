# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(document).on 'click', '.editable_answer', (e) ->
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#answer_"+answer_id).show()
    $('#answer_errors_'+answer_id).html('')

  $(document).on 'click', '.alert', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#answer_" + answer_id).hide()
    $('.editable_answer').show()

  $(document).on 'click', '#edit_question_link', (e) ->
    e.preventDefault()
    $("#edit_question_form").show()

  $(document).on 'click', '#cancel_question_edit', (e) ->
    e.preventDefault()
    $('.question_errors').html('')
    $("#edit_question_form").hide()

  $('.editable_answer_form').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $("#answer_text_" + answer.id).html(answer.body)
    $('.editable_answer').show()
    $(this).hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    answer_id = $(this).data('answerId')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#answer_errors_'+answer_id).append(value)

  $('.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(".answers").append(answer.body)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer_errors').append(value)

$(document).ready(ready)
$(document).on('page:load',ready)