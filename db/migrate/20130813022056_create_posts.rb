class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :entitle
      t.string :author
      t.string :type
      t.string :keywords
      t.integer :views
      t.integer :comments
      t.text :text

      t.timestamps


      t.index([:title], unique: true)
      t.index([:entitle], unique: true)
    end
  end
end
