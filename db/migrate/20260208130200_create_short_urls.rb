class CreateShortUrls < ActiveRecord::Migration[7.2]
  def change
    create_table :short_urls do |t|
      t.string :original_url, null: false
      t.string :code, null: false
      t.integer :clicks_count, null: false, default: 0
      t.timestamps
    end

    add_index :short_urls, :code, unique: true
    add_index :short_urls, :original_url
  end
end
