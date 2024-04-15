# frozen_string_literal: true

# Error module to Handle errors globally
module Error::ErrorHandler
  def self.included(clazz)
    # When this module is included in a class, the following code is evaluated.
    clazz.class_eval do
      # Rescue from ActiveRecord::RecordNotFound exception and respond with a 404 status code.
      rescue_from ActiveRecord::RecordNotFound do |e|
        respond('not_found', 404, e.to_s)
      end

      # Rescue from ActionController::BadRequest exception and respond with a 400 status code.
      rescue_from ActionController::BadRequest do |e|
        respond('bad_request', 400, e.to_s)
      end
    end
  end

  private

  # Method to generate and render the JSON response for errors.
  def respond(_error, _status, _message)
    # Generate JSON response using the Error::Helpers::Render module.
    json = Error::Helpers::Render.json(_error, _status, _message)
    # Log the error message.
    Rails.logger.info "RequestID[#{request.request_id}]: error_message: #{json['message']}"
    # Render the JSON response with the specified status code.
    render json: json, status: _status
  end
end
