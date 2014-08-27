class CreateSpreePromotionActionVariants < ActiveRecord::Migration
  def change
    create_table :spree_promotion_action_variants do |t|
      t.references :promotion_action, index: true
      t.references :variant, index: true

      t.timestamps
    end
  end
end
