class CreateWorkoutsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string    :type
      t.integer   :duration
      t.integer   :user_id
    end
  end
end
