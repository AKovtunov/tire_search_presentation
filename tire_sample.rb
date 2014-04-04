require 'benchmark'
require 'benchmark/ips'
require './tire_user_model.rb'

#
# User.tire.index.create(:mappings => User.tire.mapping_to_hash, :settings => User.tire.settings)
#User.tire.index.reindex('users',:mappings => User.tire.mapping_to_hash,:settings => User.tire.settings)
# User.tire.index.delete
User.create! name: 'Alex Kovtunov'
User.create! name: 'Alexander Kovtunov'
User.create! name: 'Marco Polo'
User.create! name: 'Emma Watson'
User.create! name: 'Leonardo Di Caprio'
User.create! name: 'Colin mcRye'
User.all.each do |user|
  puts "Created user #{user}"
end
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

User.all.each {|usr| usr.delete} #need for reindex tire

# suggestions = User.simple_suggestions({search_query:"Alex"})
# puts "Available corrections: #{suggestions.results.texts.join(', ')}"
# Benchmark.ips do |x|
#   x.report('simple search') { User.simple_search({search_query:"Alex"}) }
#   x.report('full search') { User.search({search_query:"Alex"}) }
#   x.report('simple suggestion') { User.simple_suggestions({search_query:"Alex"}) }
#   x.report('full suggestion') { User.suggestions({search_query:"Alex"}) }
#   x.report('simple_search_with_suggestions'){ User.simple_search_with_suggestions({search_query:"Alex"}) }
# end

# suggestions = User.suggestions({search_query:"Alex"})
# suggestions.results.suggestions.each do |name, options|
#   puts "Suggestion returned for #{name}:\n"
#   options.each do |option|
#     puts "* Raw result: #{option}"
#   end
# end

# search = User.search({search_query:"alexandar koftunov"})
# puts "Real ones:"
# puts search[:real].results.inspect
# puts "Possible ones:"
# puts search[:possible].results.inspect



# Benchmark.bm do |x|
#   x.report('simple search') { User.simple_search({search_query:"Alex"}) }
#   x.report('full search') { User.search({search_query:"Alex"}) }
#   x.report('simple suggestion') { User.simple_suggestions({search_query:"Alex"}) }
#   x.report('full suggestion') { User.suggestions({search_query:"Alex"}) }
#   x.report('simple_search_with_suggestions'){ User.simple_search_with_suggestions({search_query:"Alex"}) }
# end



