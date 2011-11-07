require 'krembo_i18nizer/engine'
require 'krembo_i18nizer/rack/browser_instrumentation'
require 'krembo_i18nizer/i18n'
require 'krembo_i18nizer/hash'

module KremboI18nizer
  class Railtie < Rails::Railtie
    initializer "krembo_i18nizer.start_plugin" do |app|
      app.config.middleware.use "::KremboI18nizer::Rack::BrowserInstrumentation"
    end
  end
end
