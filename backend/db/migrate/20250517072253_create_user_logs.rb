class CreateUserLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_logs do |t|
      t.string :user_id
      t.string :action
      t.string :path
      t.datetime :timestamp
      t.jsonb :metadata

      t.timestamps
    end
  end
end
