module Spree
  class Promotion
    module Actions
      class CreateVariantAdjustments < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        has_many :promotion_action_variants, foreign_key: :promotion_action_id
        has_many :variants, through: :promotion_action_variants

        accepts_nested_attributes_for :promotion_action_variants

        before_validation -> { self.calculator ||= Calculator::PercentOnLineItem.new }

        def perform(options = {})
          order, promotion = options[:order], options[:promotion]
          create_unique_adjustments(order, order.line_items) do |line_item|
            adjustable_variant_ids.present? and adjustable_variant_ids.include?(line_item.variant.id)
          end
        end

        def compute_amount(line_item)
          return 0 unless adjustable_variant_ids.present? and adjustable_variant_ids.include?(line_item.variant.id)
          [line_item.amount, compute(line_item)].min * -1
        end

        def adjustable_variant_ids
          variants.map{ |variant| variant.is_master? ? variant.product.variants.map(&:id) << variant.id : variant.id }.flatten
        end

        def variant_ids_string
          variant_ids.join(',')
        end

        def variant_ids_string=(s)
          self.variant_ids = s.to_s.split(',').map(&:strip)
        end
      end
    end
  end
end
