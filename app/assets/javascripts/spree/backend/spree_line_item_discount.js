// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'

$.fn.variantPicker = function () {
  'use strict';

  this.select2({
    minimumInputLength: 1,
    multiple: true,
    initSelection: function (element, callback) {
      $.get(Spree.routes.variants_api, {
        q: { id_in: element.val().split(',') },
        token: Spree.api_key
      }, function (data) {
        callback(data.variants);
      });
    },
    ajax: {
      url: Spree.routes.variants_api,
      datatype: 'json',
      data: function (term, page) {
        return {
          q: {
            product_name_or_sku_cont: term,
          },
          token: Spree.api_key
        };
      },
      results: function (data, page) {
        var variants = data.variants ? data.variants : [];
        return {
          results: variants
        };
      }
    },
    formatResult: function (variant) {
      return variant.name + ' ' + variant.sku;
    },
    formatSelection: function (variant) {
      return variant.name + ' ' + variant.sku;
    }
  });
};

$(document).ready(function () {
  $('.variant_picker').variantPicker();
});
