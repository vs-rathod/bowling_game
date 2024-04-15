# Module Error::Helpers
module Error::Helpers
  # Class to handle rendering of JSON responses for errors
  class Render
    # Method to generate JSON response for errors
    def self.json(_error, _status, _message)
      {
        status: _status,  # HTTP status code of the response
        error: _error,    # Error type or identifier
        message: _message,  # Error message
        success: false    # Indicates failure in processing the request
      }.as_json
    end
  end
end
