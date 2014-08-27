module SpreeLineItemDiscount
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_line_item_discount'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.register.promotion_action" do |app|
      app.config.spree.promotions.actions << Spree::Promotion::Actions::CreateVariantAdjustments
    end

    config.to_prepare &method(:activate).to_proc
  end
end
