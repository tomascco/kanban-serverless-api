# frozen_string_literal: true

require_relative 'lambda_base'

class FetchLists < LambdaBase
  def handler(event:, context:)

    username = event.dig('requestContext', 'authorizer', 'claims', 'cognito:username')

    result = table.query({
      key_condition_expression: '#user = :username',
      expression_attribute_names: {
        '#user' => 'User'
      },
      expression_attribute_values: {
        ':username' => username
      }
    })

    {
      body: JSON.fast_generate(result.items),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200
    }
  end
end
