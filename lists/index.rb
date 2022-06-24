require 'json'
require 'aws-sdk-dynamodb'
require 'singleton'

module Lists
  class Index
    include Singleton

    def self.handler(...)
      instance.handler(...)
    end

    def initialize
      @table = Aws::DynamoDB::Table.new(ENV.fetch('LISTS_TABLE'), Aws::DynamoDB::Client.new)
    end

    def handler(event:, context:)
      result = table.scan.items

      {
        body: JSON.fast_generate(result),
        headers: {'Content-Type' => 'application/json'},
        statusCode: 200,
      }
    end

    private

    attr_reader :table
  end
end
