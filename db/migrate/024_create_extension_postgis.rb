Sequel.migration do
  up do
    DB.run 'CREATE EXTENSION IF NOT EXISTS postgis'
  end

  down do
    DB.run 'DROP EXTENSION IF EXISTS postgis'
  end
end
