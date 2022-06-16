require 'json'

module Lists
  module Index
    def self.handler(event:, context:)
      {statusCode: 200, body: JSON.generate({hi: 'ya'})}
    end
  end
end
