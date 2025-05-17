class UserLog < ApplicationRecord
  validates :user_id, presence: true
  validates :action, presence: true
  validates :timestamp, presence: true

  # メタデータはJSONB型で、追加の情報を柔軟に保存できます
  validates :metadata, presence: true

  # デフォルトでは新しい順に並べます
  default_scope { order(timestamp: :desc) }

  # ユーザーIDでフィルタリング
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  
  # アクションタイプでフィルタリング
  scope :with_action, ->(action) { where(action: action) }
end
