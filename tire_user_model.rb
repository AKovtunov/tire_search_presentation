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
    indexes :random_address, :type => 'string'
    indexes :new_rand, :type => 'string'
  end

  def to_indexed_json
    to_json(methods: [:random_address, :new_rand])
  end

  def random_address 
    "Kirova st., house ##{Random.rand(100)}"
  end

  def new_rand
    "H #{Random.rand(100)}"
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

  def self.simple_suggestions(params)
    Tire.suggest('users') do
      # Notice that for standalone API, the block method is `suggestion` rather than `suggest`:
      #
      suggestion :term_suggest do
        text params[:search_query]
        term :name, size: 3, sort: 'frequency'
      end

    end
  end

  #https://github.com/karmi/retire/blob/master/examples/tire-dsl.rb suggest
  def self.suggestions(params)
    Tire.search 'users' do

      # To define a suggest using the term suggester, first provide a custom name for the suggest.
      #
      suggest :suggest_name do
        # Specify the input text.
        #
        text params[:search_query]
        # Then, define the field you want to use for suggestions and any options.
        #
        term :name, size: 3, sort: 'frequency'
      end

      # To define a suggest using the `phrase` suggest, use a different name.
      suggest :phrase_suggest_name do
        # Specify the text input text.
        #
        text params[:search_query]
        # Again, define the field you want to use for suggestions and any options.
        #
        phrase :name, size: 3 do
          # Optinally, configure the `smoothing` option...
          #
          smoothing :stupid_backoff, discount: 0.5

          # ...or the `generator` option.
          generator :name, min_word_len: 1
        end
      end
    end
  end

# The results will be available in the `suggestions` property (which is iterable)
#



  def self.simple_search_with_suggestions(params)
    original_query = params[:search_query].tr('^A-Za-z0-9 ', '')
    params[:search_query] = original_query.split(" ").map { |a| a<<("*") }.join(" ")
    tire.search(load: true) do
      query { string params[:search_query], default_operator: "AND" } if params[:search_query].present?
      sort do
        by :name
      end
      suggest :phrase_suggest_name do
        text original_query
        phrase :name, size: 3 do
          smoothing :stupid_backoff, discount: 0.5
          generator :name, min_word_len: 1
        end
      end
    end
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

  

  def self.reset_index
    Tire.index 'users' do
      delete
      create
    end
  end
end
