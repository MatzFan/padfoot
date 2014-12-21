Sequel.migration do
  change do

    create_table(:parishes) do
      Integer :number, primary_key: true, auto_increment: false #PK
      String :name, null: false
    end

    create_table(:app_categories) do
      String :code, primary_key: true #PK
      String :name
    end

    create_table(:app_statuses) do
      String :name, primary_key: true #PK
    end

    create_table(:app_officers) do
      String :name, primary_key: true #PK
    end

    create_table(:parish_aliases) do
      String :name, primary_key: true #PK
    end

    create_table(:agent_aliases) do
      String :name, primary_key: true #PK
    end

  end
end
