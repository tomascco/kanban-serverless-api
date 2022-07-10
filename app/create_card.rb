# frozen_string_literal: true

require 'securerandom'
require_relative 'lambda_base'

class CreateCard < LambdaBase
  def handler(event:, context:)
    username = event.dig('requestContext', 'authorizer', 'claims', 'cognito:username')

    list_uuid = event.dig('pathParameters', 'listUUID')

    card_params = JSON.parse(event['body']).fetch('card')
    card_uuid = SecureRandom.uuid

    table.put_item({
      item: {
        'User' => username,
        'ListsAndCardsCollection' => "#{list_uuid}##{card_uuid}",
        'name' => card_params.fetch('name'),
        'description' => card_params.fetch('description')
      }
    })

    {
      body: JSON.fast_generate({card: {uuid: card_uuid, **card_params}}),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200
    }
  end
end
