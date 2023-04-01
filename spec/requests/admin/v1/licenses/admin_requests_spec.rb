require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Licenses as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 10) }

    it "returns 10 Licenses" do
      get url, headers: auth_header(user)
      expect(body_json['licenses'].count).to eq 10
    end

    it "returns 10 first Licenses" do
      get url, headers: auth_header(user)
      expected_licenses = licenses[0..9].as_json(only: %i(id key game_id user_id))
      expect(body_json['licenses']).to match_array expected_licenses
    end
  end

end
