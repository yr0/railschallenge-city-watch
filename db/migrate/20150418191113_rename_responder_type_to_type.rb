class RenameResponderTypeToType < ActiveRecord::Migration
  def change
    rename_column :responders, :responder_type, :type
  end
end
