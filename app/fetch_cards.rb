# frozen_string_literal: true

require_relative 'lambda_base'

class FetchCards < LambdaBase
  def handler(event:, context:)
    username = event.dig('requestContext', 'authorizer', 'claims', 'cognito:username')
    list_uuid = event.dig('pathParameters', 'listUUID')

    result = table.query({
      key_condition_expression: '#user = :username AND begins_with(ListsAndCardsCollection, :list_uuid)',
      expression_attribute_names: {
        '#user' => 'User'
      },
      expression_attribute_values: {
        ':username' => username,
        ':list_uuid' => list_uuid
      }
    })

    {
      body: JSON.fast_generate(result.items),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200
    }
  end
end
