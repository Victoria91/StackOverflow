# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  questionId = $('.answers').data('questionId')

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
    $('#answer_errors_'+answer_id).html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#answer_errors_'+answer_id).append(value)

  $('.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    $('.answer_errors').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
     $('.answer_errors').append(value)

  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    answer = $.parseJSON(data['answer'])
    if (answer.created_at == answer.updated_at)
      $('.new_answer #answer_body').val('')
      $(".answers").append('<hr>' + '<i>Your answer</i><br/>' + answer.body)
    else
      $("#answer_text_" + answer.id).html(answer.body)
      $('.editable_answer').show()
      $('#answer_' + answer.id).hide()

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append('<p><a href="questions/'+question.id+'" id="question_' + question.id + '">' + question.title + '</a></p>')
    $('#question_' + question.id).animate({color: "#f00"}, 2000).animate({color: "#0078a0"}, 2000)

$(document).ready(ready)
$(document).on('page:load',ready)