namespace :sq do
  namespace :parishes do
    desc "Populates parishes table"
    task :create do
      fail 'One or more Parishes already exist!' if Parish.count > 0
      (1..12).each { |i| Parish.create(number: i, name: PARISHES[i - 1]) }
    end
  end
end
