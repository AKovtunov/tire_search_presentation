require './tire_user_model.rb'
User.create! name: 'Alexander Kovtunov', country:"Ukraine"
User.create! name: 'Alex Kovtunov', country:"Ukraine"
User.create! name: 'Alexandr Kovtunov', country:"Ukraine"
User.create! name: 'Julia Roberts', country:"Ukraine"
User.create! name: 'Dart Vader', country:"Death Star"
User.all.each {|usr| puts "Created user #{usr.name} from #{usr.country} \n"}

# search = User.search("Alexander!*$&!@$")
# puts search.results.inspect
#suggest = User.suggestions("Darth")
#puts suggest.results.suggestions.each {|suggestion| puts "Suggested result: #{suggestion.inspect}"}
#puts "Avalible corrections: #{suggest.results.texts.join(', ')}"
#link_to "#{correction}", search_path(correction.country)
search = User.search_with_suggestions("Julai")
puts "Real results:"
unless search[:real].empty?
	search["real"].each do |result|
		puts result.inspect
	end
end
# puts search.inspect
# search["real"].each do |result|
# 	puts result.inspect
# end
puts "Possible results:"

unless search[:possible].empty?
	search[:possible].each do |result|
		puts result.inspect
	end
end
User.all.each {|usr| usr.delete }