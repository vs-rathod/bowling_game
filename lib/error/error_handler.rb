# frozen_string_literal: true

# Error module to Handle errors globally
module Error::ErrorHandler
  def self.included(clazz)
    clazz.class_eval do
      rescue_from ActiveRecord::RecordNotFound do |e|
        respond('not_found', 404, e.to_s)
      end

      rescue_from ActionController::BadRequest do |e|
        respond('bad_request', 400, e.to_s)
      end
    end
  end

  private

  def respond(_error, _status, _message)
    json = Error::Helpers::Render.json(_error, _status, _message)
    Rails.logger.info "RequestID[#{request.request_id}]: error_message: #{json['message']}"
    render json: json, status: _status
  end
end
