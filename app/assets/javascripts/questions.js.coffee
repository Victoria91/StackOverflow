# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  questionId = $('.answers').data('questionId')
  question_author = $('.question').data('author')
  signed_in = $('.question').data('signedIn')
  user_id = $('.main .row').data('userId')

  $(document).on 'click', '.answer', (e) ->
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#accept_answer_" + answer_id).hide()
    $("#answer_form_"+answer_id).show()
    $('#answer_errors_' + answer_id).html('')

  $(document).on 'click', '.alert', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#comment_answer_" + answer_id).hide()
    $("#answer_form_" + answer_id).hide()
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
    $(".question .comments").hide()
    $("#new_comment").hide()

  $(document).on 'click', '#cancel_question_edit', (e) ->
    e.preventDefault()
    $('.question_errors').html('')
    $("#edit_question_form").hide()
    $(".question .comments").show()

  $(document).on 'click', '.show_comment_form', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#comment_answer_" + answer_id).show()

  $(document).on 'click', '.show_comments', (e) ->
    e.preventDefault()
    parent_id = $(this).data('parentId')
    $("#comments_" + parent_id).show()
    $(this).hide()
    $(this).next().hide()

  $(document).on 'click', '.hide_comments', (e) ->
    e.preventDefault()
    parent_id = $(this).data('parentId')
    $("#comments_" + parent_id).hide()
    $('#show_comments_link_' + parent_id).show()
    $('#show_comments_link_' + parent_id).next().show()

  $('.editable_answer_form').bind 'ajax:error', (e, xhr, status, error) ->
    answer_id = $(this).data('answerId')
    $('#answer_errors_'+answer_id).html('')
    errors = $.parseJSON(xhr.responseText)['errors']
    $.each errors, (index, value) ->
      $('#answer_errors_'+answer_id).append(value)

  $('.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)['answer']
    $('.new_answer #answer_body').val('') 
    $('.answers').append('<div id="answer_' + answer.id + '"></div>')
    $('#answer_' + answer.id).append('<hr>') 
    $('#answer_' + answer.id).append(HandlebarsTemplates["inactive_vote"](answer))
    $('#answer_' + answer.id + ' .votes').append(HandlebarsTemplates["accept"](answer)) if question_author?
    $('#answer_' + answer.id).append(HandlebarsTemplates["answer"](answer))
    $('#answer_' + answer.id).append(HandlebarsTemplates["answer_form"](answer))
    add_comment_staff(answer)
  .bind 'ajax:error', (e, xhr, status, error) ->
    $('.answers').after('<div class="answer_errors" id="new_answer_error"></div>');
    errors = $.parseJSON(xhr.responseText)['errors']
    $.each errors, (index, value) ->
      $('#new_answer_error').append(value).animate({ opacity: "hide" }, 5000);

  is_answer_author = (answer_field, answer)  -> 
    answer_field.val() == answer.body

  add_comment_staff = (answer) ->
    $('#answer_' + answer.id).append(HandlebarsTemplates["comment_form"](answer))
    $('#answer_' + answer.id).append('<br><div class="comments"></div>')

  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    answer = $.parseJSON(data['answer'])
    unless $('#answer_' + answer.id).length
      unless user_id == answer.user_id 
        $('.answers').append('<div id="answer_' + answer.id + '"></div>')
        $('#answer_' + answer.id).append('<hr>')
        if question_author?
          $('#answer_' + answer.id).append(HandlebarsTemplates["vote_for_answer"](answer))
          $('#answer_' + answer.id).append('<div id="' + answer.id + '">'+ answer.body+'</div><br/>')
          # add_comment_staff()
        else if signed_in?
          $('#answer_' + answer.id).append(HandlebarsTemplates["vote"](answer))
          $('#answer_' + answer.id).append('<div id="' + answer.id + '">'+ answer.body+'</div>')
          add_comment_staff(answer)
          $('#answer_' + answer.id).append(HandlebarsTemplates["comment_link"](answer))
        else
          $('#answer_' + answer.id).append('<div id="answer_text_"'+ answer.id+'>'+ answer.body+'</div>')
    else
      $("#answer_text_" + answer.id).html(answer.body)
      $('.answer').show()
      $("#accept_answer_" + answer.id).show() if question_author?
      $('#answer_form_' + answer.id).hide()
    $('#answer_text_' + answer.id).animate({color: "#f00"}, 2000).animate({color: "#000"}, 2000)

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = (data['question'])
    $('.questions').prepend(HandlebarsTemplates["question_summary"](question))
    $('#question_summary_' + question.id + ' .summary').animate({color: "#f00"}, 2000).animate({color: "#000"}, 2000)

  $ ->
    $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
      width: '200px'

$(document).ready(ready)
$(document).on('page:load',ready)