# Let's require all models.
models_dir = File.join(File.expand_path('../models', __FILE__), '*.rb')
Dir[models_dir].each do |model|
  model_name = File.basename(model, '.rb')
  autoload ActiveSupport::Inflector.camelize(model_name), model
end

# Now let's load all our routes (controllers).
routes_dir = File.join(File.expand_path('../routes', __FILE__), '*.rb')
Dir[routes_dir].each do |route|
  route_name = File.basename(route, '.rb')
  autoload ActiveSupport::Inflector.camelize(route_name), route
end
