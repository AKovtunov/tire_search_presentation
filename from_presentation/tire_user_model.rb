require 'active_support'
require 'active_record'
require 'tire'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.connection.instance_eval do
  create_table(:users) { |t| t.string :name; t.string :country }
end

class User < ActiveRecord::Base; 
	include Tire::Model::Search
	include Tire::Model::Callbacks

	mapping do 
		indexes :name, type: "string"
		indexes :country, type: "string"
		indexes :random_adress, type: "string"
		indexes :token
	end

	def to_indexed_json
		to_json(methods: [:random_adress])
	end

	def random_adress
		"Ukraine, ##{Random.rand(100)}"
	end

	def test
		"tokend"
	end

	def self.search keyword
		keyword = keyword.tr('^A-Za-z0-9','')
		tire.search(load:true) do
			query {string keyword, default_operator: "AND"} if keyword.present?
			sort do
				:name
			end
		end
	end
	#hrose
	#Did you mean "horse" ?
	def self.suggestions keyword
		Tire.suggest('users') do
			suggestion :term_suggest do #phrase_sugges; smoothing
				text keyword
				term :name, size: 3, sort: 'frequency'
			end
		end
	end

	def self.search_with_suggestions keyword
		#{}"Alex Kovt"
		#{}"Alex* Kovt*"
		results = Hash.new
		keyword = keyword.tr('^A-Za-z0-9','')
		keyword_real = keyword.split(" ").map{|part_name| part_name<<("*")}.join(" ")
		results[:real] = tire.search(load:true) do
			query {string keyword_real, default_operator: "AND"} if keyword_real.present?
			sort do
				:name
			end
		end
		#Alex
		#Alix Alox
		keyword_possible = keyword.split(" ").map{|part_name| part_name<<("~")}.join(" ") 
		results[:possible] = tire.search(load:true) do
			query {string keyword_possible, default_operator: "AND"} if keyword_possible.present?
			sort do
				:name
			end
		end

		return results

	end
end