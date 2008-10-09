# desc "Explaining what the task does"
# task :request_streams do
#   # Task goes here
# end
namespace :request_streams do
  namespace :db do
    task :create => :environment do
      generate_migration(["request_streams", "create_request_streams"])
    end
  end
  
  def generate_migration(args)
    require 'rails_generator'
    require 'rails_generator/scripts/generate'

    if ActiveRecord::Base.connection.supports_migrations?
      Rails::Generator::Scripts::Generate.new.run(args)
    else
      raise "Task unavailable to this database (no migration support)"
    end
  end
end