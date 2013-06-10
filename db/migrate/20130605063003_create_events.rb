class CreateEvents < ActiveRecord::Migration
  def up
     create_table :events do |t|
      t.string :description
      t.string :logo
      t.text :date
      t.integer :position
      t.timestamps
    end

    Application::New.reset_column_information
    while Application::New.count < 3
      Application::New.create
    end
  end

  def down
    drop_table :events
  end
end
