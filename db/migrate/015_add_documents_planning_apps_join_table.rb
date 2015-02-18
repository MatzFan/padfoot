Sequel.migration do
  change do

    create_table(:documents_planning_apps) do # alphabetical & plural
      String :page_link
      foreign_key :document_id, :documents, null: false
      foreign_key :app_ref, :planning_apps, null: false, type: String
      primary_key [:document_id, :app_ref]
    end

  end
end
