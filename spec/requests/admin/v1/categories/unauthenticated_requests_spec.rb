require 'rails_helper'

RSpec.describe "Admin V1 Categories without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

end
