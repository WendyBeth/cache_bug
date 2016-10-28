class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.integer :post_id
      t.string :title

      t.timestamps
    end
  end
end
