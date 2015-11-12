Sequel.migration do

  change do
    alter_table :transactions do
      add_column :pa, String
      add_column :e, String
      add_column :nameSeq, Integer
      add_column :docSeq, Integer
      add_column :page_suffix, String
    end
  end

end
