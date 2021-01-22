class PostCommentsController < ApplicationController
  def create
    cook = Cook.find(params[:cook_id])
    comment = PostComment.new(post_comment_params)
    comment.user_id = current_user.id
    comment.cook_id = cook.id
    comment.save
    redirect_to cook_path(cook), notice: "コメントしました！"
  end

  def destroy
    PostComment.find_by(id: params[:id], cook_id: params[:cook_id]).destroy
    redirect_to cook_path(params[:cook_id]), notice: "コメントを削除しました。"
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
