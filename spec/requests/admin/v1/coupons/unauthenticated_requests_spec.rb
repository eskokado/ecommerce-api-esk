require 'rails_helper'

RSpec.describe "Admin V1 Coupons without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do
    let(:url) { "/admin/v1/coupons" }
    let!(:coupons) { create_list(:coupon, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end
end
