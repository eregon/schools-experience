module Schools
  module DFESignInAPI
    class Client
      def self.enabled?
        [
          ENV['DFE_SIGNIN_API_CLIENT'],
          ENV['DFE_SIGNIN_API_SECRET']
        ].map(&:presence).all?
      end
      delegate :enabled?, to: :class

    private

      def response
        return [] unless enabled?

        resp = Faraday.new.get(endpoint) do |req|
          req.headers['Authorization'] = "bearer #{token}"
          req.headers['Content-Type']  = 'application/json'
        end

        JSON.parse(resp.body)
      end

      def token
        JWT.encode(payload, ENV.fetch('DFE_SIGNIN_API_SECRET'))
      end

      def payload
        {
          iss: ENV.fetch('DFE_SIGNIN_API_CLIENT'),
          aud: 'signin.education.gov.uk'
        }
      end
    end
  end
end
