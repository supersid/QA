require "will_paginate"
class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])   
    if @user.save
      UserMailer.activation(@user).deliver
      unless @user.active?
        flash[:message] = "Your account has been successfully created. An email has been sent to your account. Please click the link to activate your account"
        redirect_to message_url
      end
    else
      flash.now[:error] = "Please fix the errors"
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @questions = Question.order().includes(:categories).paginate(:page => params[:page], :per_page => 10)
    render :layout => "inner"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update    
    @user = current_user    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your profile has been successfully updated."
      redirect_to edit_user_url(@user)
    else      
      flash.now[:error] = "Your profile could not be updated."
      render "edit"
    end
  end

  def my_qa    
    @my_questions = current_user.questions.paginate(:page => params[:page], :per_page => 10)
    @my_answers = current_user.answers.includes(:question).paginate(:page => params[:page], :per_page => 10)
  end

  def delete
  end

  def activate
    @user = User.find_by_perishable_token(params[:token])
    if @user
      @user.activate!
      @user.reset_perishable_token!
      @user.save(:validate => false)
      flash[:notice] = "Awesome! Your account has been activated. Please log in with your email and password"
      redirect_to root_url
    else
      flash[:notice] = "Your token seems to be invalid. Please request for a new token"
      redirect_to root_url
    end
  end

end
