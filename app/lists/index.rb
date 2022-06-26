# frozen_string_literal: true

require_relative '../lambda_base'

module Lists
  class Index < LambdaBase
    def table_name
      ENV.fetch('LISTS_TABLE')
    end

    def handler(event:, context:)
      result = table.scan.items

      {
        body: JSON.fast_generate(result),
        headers: {'Content-Type' => 'application/json'},
        statusCode: 200,
      }
    end
  end
end
