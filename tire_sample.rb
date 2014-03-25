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
# Benchmark.ips do |x|
#   x.report('simple search') { User.search({search_query:"Alex"}) }
#   x.report('full search') { User.simple_search({search_query:"Alex"}) }
# end

puts "Add some more names "
User.create! name: 'Alex Bierbrauer'
User.create! name: 'Alexander Bierbrauer'
User.create! name: 'Alexeus Bierbrauer'
User.create! name: 'Alexandr Bierbrauer'

# Benchmark.ips do |x|
#   x.report('simple search') { User.search({search_query:"Alex"}) }
#   x.report('full search') { User.simple_search({search_query:"Alex"}) }
# end

puts "And even more names "
User.create! name: 'Alexan Somesecondname'
User.create! name: 'Alexandre Somesecondname'
User.create! name: 'Violett Somesecondname'
User.create! name: 'Sedrick Somesecondname'

# Benchmark.ips do |x|
#   x.report('simple search') { User.search({search_query:"Alex"}) }
#   x.report('full search') { User.simple_search({search_query:"Alex"}) }
# end

puts "And different ones "
User.create! name: 'Marco Polo'
User.create! name: 'Emma Watson'
User.create! name: 'Leonardo Di Caprio'
User.create! name: 'Colin mcRye'
#https://github.com/karmi/retire/blob/master/examples/tire-dsl.rb suggest
s = Tire.suggest('users') do

  # Notice that for standalone API, the block method is `suggestion` rather than `suggest`:
  #
  suggestion :term_suggest do
    text 'Alexandir Kovtuniv'
    term :name, size: 3, sort: 'frequency'
  end

end

puts "Available corrections: #{s.results.texts.join(', ')}"