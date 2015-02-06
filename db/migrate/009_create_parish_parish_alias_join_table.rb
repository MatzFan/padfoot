Sequel.migration do
  change do

    create_table(:parishes_parish_aliases) do
      foreign_key :number, :parishes, null: false, type: Integer
      foreign_key :name, :parish_aliases, null: false, type: String
      primary_key [:number, :name]
      index [:number, :name]
    end

  end
end
