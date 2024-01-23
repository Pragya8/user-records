# lib/liquid_handler.rb
class LiquidHandler
  def self.call(template, source)
    "Liquid::Rails::TemplateHandler.new(self).render(#{template.source.inspect}, local_assigns)"
  end
end
