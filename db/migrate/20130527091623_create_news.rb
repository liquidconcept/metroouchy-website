class CreateNews < ActiveRecord::Migration
  def up
     create_table :news do |t|
      t.string :category
      t.string :title
      t.string :body
      t.text :description
      t.timestamps
    end

    Application::New.reset_column_information
    while Application::New.count < 3
      Application::New.create
    end
  end

  def down
    drop_table :news
  end
end
