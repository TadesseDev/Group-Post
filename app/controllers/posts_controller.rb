class PostsController < ApplicationController
  before_action :set_post, only: [:destroy, :update, :show]
  before_action :param_filter, only: [:create]

  def show
    respond_to do |format|
        format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          'active-content', ShowPostComponent.new(post: @post).render_in(view_context))
      }
        format.html { redirect_to user_path(current_user) }
      end
  end

  def update
  end

  def destroy
  end

  def create
        post = Post.new(title: param_filter[:title],body: param_filter[:body],user_id: params[:user_id],
          group_id: params[:group_id])
    respond_to do |format|
      if post.save!
        format.turbo_stream {
        render turbo_stream: turbo_stream.prepend(
          'posts', PostComponent.new(post: post).render_in(view_context))
      }
        format.html { redirect_to user_path(current_user) }
      end
    end
  end
  private
  def set_post
    @post=Post.includes(:user, :group).find(params[:id])
  end
  def param_filter
    params.require(:post).permit(:title, :body)
  end
end
