# config/initializers/liquid.rb

Rails.application.config.after_initialize do
  ActionView::Template.register_template_handler(:liquid, LiquidHandler)
end
