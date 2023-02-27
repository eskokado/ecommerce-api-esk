shared_examples "paginatable concern" do |factory_name|
  context "when records fits page size" do
    let!(:records) { create_list(factory_name, 20) }

    context "when :page and :length are empty" do
      it "returns default 10 records" do
        paginated_records = described_class.paginate(nil, nil)
        expect(paginated_records.count).to eq 10
      end

      it "matches first 10 records" do
        paginated_records = described_class.paginate(nil, nil)
        expected_records = described_class.all[0..9]
        expect(paginated_records).to eq expected_records
      end
    end
  end
end
