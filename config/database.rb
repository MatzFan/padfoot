Sequel::Model.plugin(:schema)
Sequel::Model.plugin(:json_serializer)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
DB = case Padrino.env
  when :development then Sequel.connect("postgres://localhost/padfoot_development", loggers: [logger])
  when :production  then Sequel.connect(ENV['DATABASE_URL'], loggers: [logger])
  when :test        then Sequel.connect("postgres://localhost/padfoot_test", loggers: [logger])
end
