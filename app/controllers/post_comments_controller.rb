class PostCommentsController < ApplicationController
  def create
    @cook = Cook.find(params[:cook_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.user_id = current_user.id
    @post_comment.cook_id = @cook.id
    @post_comment.save
    # app/views/book_comments/create.js.erbを参照する
  end

  def destroy
    @cook = Cook.find(params[:cook_id])
    PostComment.find_by(id: params[:id], cook_id: params[:cook_id]).destroy
    # app/views/book_comments/destroy.js.erbを参照する
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
