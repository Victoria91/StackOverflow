# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  questionId = $('.answers').data('questionId')
  question_author = $('.question').data('author')
  signed_in = $('.question').data('signedIn')
  # alert signed_in?

  $(document).on 'click', '.answer', (e) ->
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#accept_answer_" + answer_id).hide()
    $("#answer_"+answer_id).show()
    $('#answer_errors_' + answer_id).html('')

  $(document).on 'click', '.alert', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#comment_answer_" + answer_id).hide()
    $("#answer_" + answer_id).hide()
    $('.answer').show()
    $("#accept_answer_" + answer_id).show()

  $(document).on 'mouseover', '.answer', (e) ->
    answer_id = $(this).data('answerId')
    $("#accept_answer_" + answer_id).hide()

  $(document).on 'mouseout', '.answer', (e) ->
    answer_id = $(this).data('answerId')
    $("#accept_answer_" + answer_id).animate({ opacity: "show" }, "slow");

  $(document).on 'click', '#edit_question_link', (e) ->
    e.preventDefault()
    $("#edit_question_form").show()

  $(document).on 'click', '#cancel_question_edit', (e) ->
    e.preventDefault()
    $('.question_errors').html('')
    $("#edit_question_form").hide()

  $(document).on 'click', '.show_comment_form', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#comment_answer_" + answer_id).show()

  $('.editable_answer_form').bind 'ajax:error', (e, xhr, status, error) ->
    answer_id = $(this).data('answerId')
    $('#answer_errors_'+answer_id).html('')
    errors = $.parseJSON(xhr.responseText)['errors']
    $.each errors, (index, value) ->
      $('#answer_errors_'+answer_id).append(index + ' ' + value)

  $('.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    $('.answers').after('<div class="answer_errors" id="new_answer_error"></div>');
    errors = $.parseJSON(xhr.responseText)['errors']
    $.each errors, (index, value) ->
      $('#new_answer_error').append(index + ' ' + value).animate({ opacity: "hide" }, "slow");

  is_answer_author = (answer_field, answer)  -> 
    answer_field.val() == answer.body

  add_comment_staff = (answer) ->
    $('#' + answer.id).append(HandlebarsTemplates["comment_form"](answer))
    $('#' + answer.id).append('<br><div class="comments"></div>')

  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    answer = $.parseJSON(data['answer'])
    if (answer.created_at == answer.updated_at)
      $('.answers').append('<div id="' + answer.id + '"></div>')
      $('#' + answer.id).append('<hr>')
      if question_author?
        $('#' + answer.id).append(HandlebarsTemplates["accept"](answer))
        # add_comment_staff()
      if is_answer_author?($('.new_answer #answer_body'), answer)
        $('.new_answer #answer_body').val('')  
        $('#' + answer.id).append(HandlebarsTemplates["answer"](answer))
        $('#' + answer.id).append(HandlebarsTemplates["answer_form"](answer))
        add_comment_staff(answer)
      else if signed_in?
        $('#' + answer.id).append('<div id="' + answer.id + '">'+ answer.body+'</div>')
        add_comment_staff(answer)
      else
        $('#' + answer.id).append('<div id="answer_text_"'+ answer.id+'>'+ answer.body+'</div>')
    else
      $("#answer_text_" + answer.id).html(answer.body)
      $('.answer').show()
      $("#accept_answer_" + answer.id).show() if question_author?
      $('#answer_' + answer.id).hide()
    $('#answer_text_' + answer.id).animate({color: "#f00"}, 2000).animate({color: "#000"}, 2000)

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append('<p><a href="questions/'+question.id+'" id="question_' + question.id + '">' + question.title + '</a></p>')
    $('#question_' + question.id).animate({color: "#f00"}, 2000).animate({color: "#0078a0"}, 2000)

$(document).ready(ready)
$(document).on('page:load',ready)