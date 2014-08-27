class Spree::PromotionActionVariant < ActiveRecord::Base
  belongs_to :promotion_action, class_name: 'Spree::Promotion::Actions::CreateVariantAdjustments'
  belongs_to :variant, class_name: 'Spree::Variant'
end
