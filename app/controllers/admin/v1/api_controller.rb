module Admin::V1
  class ApiController < ApplicationController
    class ForbiddenAccess < StandardError; end

    include Devise::Controllers::Helpers
    include Authenticable

    rescue_from ForbiddenAccess do
      render_error(message: "Forbidden access", status: :forbidden)
    end

    before_action :restrict_access_for_admin!

    def self.render_error(message: nil, fields: nil, status: :unprocessable_entity)
      errors = {}
      errors['fields'] = fields if fields.present?
      errors['message'] = message if message.present?
      result = { errors: errors }
      render json: result, status: status
    end

    private

    def restrict_access_for_admin!
      raise ForbiddenAccess unless current_user.admin?
    end
  end
end
