class ChangeColumnNullToPostComments < ActiveRecord::Migration[5.2]
  def change
    change_column_null :post_comments, :comment, false
  end
end
