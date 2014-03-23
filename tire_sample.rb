require './tire_user_model.rb'
require 'benchmark'
require 'benchmark/ips'
User.create! name: 'Alex Kovtunov'
User.create! name: 'Alexander Kovtunov'
User.create! name: 'Alexeus Kovtunov'
User.create! name: 'Alexandr Kovtunov'
# search = User.search({search_query:"alexandar koftunov"})
# puts "Real ones:"
# puts search[:real].results.inspect
# puts "Possible ones:"
# puts search[:possible].results.inspect
Benchmark.ips do |x|
  x.report('simple search') { User.search({search_query:"Alex"}) }
  x.report('full search') { User.simple_search({search_query:"Alex"}) }
end

puts "Add some more names "
User.create! name: 'Alex Bierbrauer'
User.create! name: 'Alexander Bierbrauer'
User.create! name: 'Alexeus Bierbrauer'
User.create! name: 'Alexandr Bierbrauer'

Benchmark.ips do |x|
  x.report('simple search') { User.search({search_query:"Alex"}) }
  x.report('full search') { User.simple_search({search_query:"Alex"}) }
end

puts "And even more names "
User.create! name: 'Alex Somesecondname'
User.create! name: 'Alexander Somesecondname'
User.create! name: 'Alexeus Somesecondname'
User.create! name: 'Alexandr Somesecondname'

Benchmark.ips do |x|
  x.report('simple search') { User.search({search_query:"Alex"}) }
  x.report('full search') { User.simple_search({search_query:"Alex"}) }
end