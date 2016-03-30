namespace :sq do
  namespace :parishes do
    desc 'Populates parishes table with Jersey parishes'
    task :create do
      PARISHES = ['Grouville', 'St. Brelade', 'St. Clement', 'St. Helier',
                  'St. John', 'St. Lawrence', 'St. Martin', 'St. Mary',
                  'St. Ouen', 'St. Peter', 'St. Saviour', 'Trinity'].freeze
      raise 'One or more Parishes already exist!' if Parish.count > 0
      (1..12).each { |i| Parish.create(number: i, name: PARISHES[i - 1]) }
    end
  end
end
