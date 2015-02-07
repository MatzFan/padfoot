Sequel.migration do
  change do
    alter_table :parish_aliases do
      add_foreign_key :parish_num, :parishes, type: Integer
    end
  end
end
