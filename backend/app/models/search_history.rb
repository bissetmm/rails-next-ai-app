class SearchHistory < ApplicationRecord
  validates :user_id, presence: true
  validates :query, presence: true
  validates :timestamp, presence: true

  # デフォルトでは新しい順に並べます
  default_scope { order(timestamp: :desc) }

  # ユーザーIDでフィルタリング
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  
  # クエリで部分一致検索
  scope :search_query, ->(term) { where('query ILIKE ?', "%#{term}%") }
  
  # 特定の期間の検索履歴を取得
  scope :in_date_range, ->(start_date, end_date) {
    where(timestamp: start_date..end_date)
  }
end
