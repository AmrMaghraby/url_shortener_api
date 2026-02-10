class CreateClicks < ActiveRecord::Migration[7.2]
  def change
    create_table :clicks do |t|
      t.references :short_url, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.datetime :clicked_at

      t.timestamps
    end
  end
end
