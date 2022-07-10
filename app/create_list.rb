# frozen_string_literal: true

require 'securerandom'
require_relative 'lambda_base'

class CreateList < LambdaBase
  def handler(event:, context:)
    username = event.dig('requestContext', 'authorizer', 'claims', 'cognito:username')

    list_name = JSON.parse(event['body']).fetch('list').fetch('name')
    list_uuid = SecureRandom.uuid

    table.put_item({
      item: {
        'User' => username,
        'ListsAndCardsCollection' => "#{list_uuid}#metadata",
        'name' => list_name
      }
    })

    {
      body: JSON.fast_generate({list: {uuid: list_uuid, name: list_name}}),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200
    }
  end
end
