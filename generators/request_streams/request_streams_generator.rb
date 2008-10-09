class RequestStreamsGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb.template', 'db/migrate'
    end
  end
end
