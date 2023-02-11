module Admin::V1
  class ApiController < ApplicationController
    include Devise::Controllers::Helpers
    include Authenticable
  end
end
