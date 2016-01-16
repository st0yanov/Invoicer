# Let's require all models.
models_dir = File.join(File.expand_path('../models', __FILE__), '*.rb')
Dir[models_dir].each do |model|
  model_name = File.basename(model, '.rb')
  autoload ActiveSupport::Inflector.camelize(model_name), model
end
