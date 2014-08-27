module Spree
  class Promotion
    module Actions
      class CreateVariantAdjustments < CreateItemAdjustments

        has_many :promotion_action_variants, foreign_key: :promotion_action_id
        has_many :variants, through: :promotion_action_variants
        accepts_nested_attributes_for :promotion_action_variants

        def variant_ids_string
          variant_ids.join(',')
        end

        def variant_ids_string=(s)
          self.variant_ids = s.to_s.split(',').map(&:strip)
        end

        def perform(payload = {})
          order = payload[:order]
          result = false
          variants_to_adjust(order).each do |line_item|
            result ||= self.create_adjustment(line_item, order)
          end
          return result
        end

        private

        def variants_to_adjust(order)
          excluded_ids = self.adjustments.pluck(:adjustable_id)
          order.line_items.where(variant_id: variants.pluck(:id))
        end
      end
    end
  end
end
