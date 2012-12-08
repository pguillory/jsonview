module Jsonview
  class Railtie < Rails::Railtie
    initializer "Jsonview.insert_middleware" do |app|
      app.config.middleware.use "Jsonview::Middleware"
    end
  end
end
