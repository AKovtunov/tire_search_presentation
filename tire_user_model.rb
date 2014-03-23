require 'active_support'
require 'active_record'
require 'tire' #gem install tire

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.connection.instance_eval do
  create_table(:users) { |t| t.string :name }
end

class User < ActiveRecord::Base; 
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :name, :type => 'string'
  end

  def self.search(params)
    results = Hash.new
    original_query = params[:search_query].tr('^A-Za-z0-9 ', '')
    params[:search_query] = original_query.split(" ").map { |a| a<<("*") }.join(" ")
    results[:real] = tire.search(load: true) do
      query { string params[:search_query], default_operator: "AND" } if params[:search_query].present?
      sort do
        by :name
      end
    end
    params[:search_query] = original_query.split(" ").map { |a| a<<('~') }.join(" ")
    results[:possible] = tire.search(load: true) do
      query { string params[:search_query], default_operator: "AND" } if params[:search_query].present?
      sort do
        by :name
      end
    end
    return results
  end

  def self.simple_search(params)
    original_query = params[:search_query].tr('^A-Za-z0-9 ', '')
    params[:search_query] = original_query.split(" ").map { |a| a<<("*") }.join(" ")
    tire.search(load: true) do
      query { string params[:search_query], default_operator: "AND" } if params[:search_query].present?
      sort do
        by :name
      end
    end
  end

end
