class ChangeDefaultValueOfRespondersOnDuty < ActiveRecord::Migration
  def change
    change_column :responders, :on_duty, :boolean, default: false, null: false
  end
end
