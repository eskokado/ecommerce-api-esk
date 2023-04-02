require "rails_helper"

describe Admin::ModelLoadingService do
  context "when #call" do
    let!(:categories) { create_list(:category, 15) }

    context "when params are present" do
      let!(:search_categories) do
        categories = []
        15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
        categories
      end

      let(:params) do
        { search: { name: "Search" }, order: { name: :desc }, page: 2, length: 4 }
      end

      it "performs right :length following pagination" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.records.count).to eq 4
      end
    end

    context "when params are not present" do
    end
  end
end
