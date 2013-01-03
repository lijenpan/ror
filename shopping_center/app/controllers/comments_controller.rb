class CommentsController < ApplicationController
  before_filter :find_commentable
  respond_to :html, :json, :js

  def create
    @commentable.comments.create(params[:comment])
    redirect_to @commentable, :notice => t(:comment_created)
  end

  def destroy
    @commentable.comments.find(params[:id]).destroy
    redirect_to @commentable
  end

  def update
    @comment = @commentable.comments.find(params[:id])
    @comment.update_attributes(params[:comment])

    respond_with @comment
  end

  private
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end

    raise Mongoid::Errors::DocumentNotFound.new(t(:commentable_not_found, :value => value)) if @commentable.nil?
  end
end
