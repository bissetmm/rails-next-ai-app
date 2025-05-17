class CreateSearchHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :search_histories do |t|
      t.string :user_id
      t.string :query
      t.integer :results_count
      t.datetime :timestamp

      t.timestamps
    end
  end
end
