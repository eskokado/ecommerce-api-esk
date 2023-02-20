module Admin::V1
  class ApiController < ApplicationController
    include Devise::Controllers::Helpers
    include Authenticable

    def self.render_error(message: nil, fields: nil, status: :unprocessable_entity)
      errors = {}
      errors['fields'] = fields if fields.present?
      errors['message'] = message if message.present?
      result = { errors: errors }
      render json: result, status: status
    end
  end
end
