Sequel.migration do
  change do

    create_table(:documents_planning_apps) do # alphabetical & plural
      String :page_link
      foreign_key :id, :documents, null: false
      foreign_key :app_ref, :planning_apps, null: false, type: String
      primary_key [:id, :app_ref]
      index [:id, :app_ref]
    end

  end
end
