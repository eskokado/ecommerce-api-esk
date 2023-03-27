require 'rails_helper'

RSpec.describe Admin::ProductSavingService, type: :model do
  context "when #call" do
    context "sending loaded product" do
      let!(:new_categories) { create_list(:category, 2) }
      let!(:old_categories) { create_list(:category, 2) }
      let!(:product) { create(:product, categories: old_categories) }

      context "with valid params" do
        let!(:game) { product.productable }
        let(:params) { { name: "New product", category_ids: new_categories.map(&:id),
                         productable_attributes: { developer: "New company" } } }

        it "updates product" do
          service = described_class.new(params, product)
          service.call
          product.reload
          expect(product.name).to eq "New product"
        end

        it "updates :productable" do
          service = described_class.new(params, product)
          service.call
          game.reload
          expect(game.developer).to eq "New company"
        end

        it "updates to new categories" do
          service = described_class.new(params, product)
          service.call
          product.reload
          expect(product.categories.ids).to contain_exactly *new_categories.map(&:id)
        end
      end

      context "with invalid :product params" do
        let(:product_params) { attributes_for(:product, name: "") }

        it "raises NotSavedProductError" do
          expect {
            service = described_class.new(product_params, product)
            service.call
          }.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "sets validation :errors" do
          service = error_proof_call(product_params, product)
          expect(service.errors).to have_key(:name)
        end

        it "doesn't update :product" do
          expect {
            error_proof_call(product_params, product)
            product.reload
          }.to_not change(product, :name)
        end
      end

      context "with invalid :productable params" do
        let(:game_params) { { productable_attributes: attributes_for(:game, developer: "") } }

        it "raises NotSavedProductError" do
          expect {
            service = described_class.new(game_params, product)
            service.call
          }.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

      end
    end
  end
end

def error_proof_call(*params)
  service = described_class.new(*params)
  begin
    service.call
  rescue => e
  end
  return service
end
