class CommentsController < ApplicationController
  def create    
    @associated_object, @comment = comment_for(params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Your comments have been successfully save"
      redirect_to question_url(@associated_object) and return if @associated_object.is_a? Question
      redirect_to question_url(@associated_object.question) and return if @associated_object.is_a? Answer
    else      
      flash[:error] = @comment.errors.full_messages[0] + " for comments"
      redirect_to question_url(@associated_object) and return if @associated_object.is_a? Question
      redirect_to question_url(@associated_object.question) and return if @associated_object.is_a? Answer      
    end
  end

  def update
    @associated_object, @comment = comment_for(params, :update)    
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Your comments have been successfully save"
      redirect_to question_url(@associated_object) and return if @associated_object.is_a? Question
      redirect_to question_url(@associated_object.question) and return if @associated_object.is_a? Answer
    else
      flash[:error] = @comment.errors.full_messages[0] + " for comments"
      redirect_to question_url(@associated_object) and return if @associated_object.is_a? Question
      redirect_to question_url(@associated_object.question) and return if @associated_object.is_a? Answer      
    end
  end

  def delete
  end

  private

  def comment_for(params, op = :create)
    associated_object = comment =  nil
    if op == :create
      associated_object = find_associated_object(params)
      comment = associated_object.comments.build(params[:comment])      
    elsif op == :update
      associated_object = find_associated_object(params)
      comment = associated_object.comments.find(params[:id])
    end    
    [associated_object, comment]
  end

  def find_associated_object(params)
    if params[:question_id] && !params[:answer_id]
      return Question.find(params[:question_id])
    elsif params[:question_id] && params[:answer_id]
      return Answer.find(params[:answer_id])
    end    
  end
end
