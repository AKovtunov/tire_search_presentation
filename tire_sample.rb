require './tire_user_model.rb'
require 'benchmark'
require 'benchmark/ips'
User.create! name: 'Alex Kovtunov'
User.create! name: 'Alexander Kovtunov'
User.create! name: 'Alexeus Kovtunov'
User.create! name: 'Alexandr Kovtunov'
User.create! name: 'Alex Bierbrauer'
User.create! name: 'John Bierbrauer'
User.create! name: 'Alexeus Bierbrauer'
User.create! name: 'Alexandr Bierbrauer'
User.create! name: 'Alexan Somesecondname'
User.create! name: 'Alexandre Somesecondname'
User.create! name: 'Violett Somesecondname'
User.create! name: 'Sedrick Somesecondname'
User.create! name: 'Marco Polo'
User.create! name: 'Emma Watson'
User.create! name: 'Leonardo Di Caprio'
User.create! name: 'Colin mcRye'

# Benchmark.ips do |x|
#   x.report('simple search') { User.simple_search({search_query:"Alex"}) }
#   x.report('full search') { User.search({search_query:"Alex"}) }
#   x.report('simple suggestion') { User.simple_suggestions({search_query:"Alex"}) }
#   x.report('full suggestion') { User.suggestions({search_query:"Alex"}) }
#   x.report('simple_search_with_suggestions'){ User.simple_search_with_suggestions({search_query:"Alex"}) }
# end

Benchmark.bm do |x|
  x.report('simple search') { User.simple_search({search_query:"Alex"}) }
  x.report('full search') { User.search({search_query:"Alex"}) }
  x.report('simple suggestion') { User.simple_suggestions({search_query:"Alex"}) }
  x.report('full suggestion') { User.suggestions({search_query:"Alex"}) }
  x.report('simple_search_with_suggestions'){ User.simple_search_with_suggestions({search_query:"Alex"}) }
end

# search = User.search({search_query:"alexandar koftunov"})
# puts "Real ones:"
# puts search[:real].results.inspect
# puts "Possible ones:"
# puts search[:possible].results.inspect

search = User.simple_search_with_suggestions({search_query:"Alexandir"})
puts "Search returned:\n"
search.results.each do |result|
  puts result.inspect
end
search.suggestions.each do |name, options|
  puts "Suggestion returned for #{name}:\n"
  options.each do |option|
    puts "* Raw result: #{option}"
    option['options'].each do |option|
      puts "* Possible name: #{option['text']} with P=(#{option['score']})"
    end 
  end
end
# suggestions = User.suggestions({search_query:"Alex"})
# suggestions.results.suggestions.each do |name, options|
#   puts "Suggestion returned for #{name}:\n"
#   options.each do |option|
#     puts "* Raw result: #{option}"
#   end
# end


# suggestions = User.simple_suggestions({search_query:"Alex"})
# puts "Available corrections: #{suggestions.results.texts.join(', ')}"