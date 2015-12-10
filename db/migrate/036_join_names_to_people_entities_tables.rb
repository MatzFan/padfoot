Sequel.migration do

  change do
    alter_table :names do
      add_foreign_key :person_id, :people
      add_foreign_key :entity_id, :entities
    end
  end

end
