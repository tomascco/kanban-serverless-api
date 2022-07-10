# frozen_string_literal: true

require 'securerandom'
require_relative '../lambda_base'

class FetchUserListsAndCards < LambdaBase
  NAME_NOT_INFORMED = {
    body: JSON.fast_generate({message: 'Name not informed'}),
    headers: {'Content-Type' => 'application/json'},
    statusCode: 400,
  }.freeze

  ErrorFromDynamoDB = ->(message) {
    {
      body: JSON.fast_generate({message: message}),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 400,
    }
  }

  def handler(event:, context:)
    params = JSON.parse(event['body'])
    return NAME_NOT_INFORMED if params['name'].nil?

    item = {'uuid' => SecureRandom.uuid, 'name' => params['name'].strip}

    begin
      table.put_item({item: item})
    rescue Aws::DynamoDB::Errors::ServiceError => exception
      return ErrorFromDynamoDB.call(exception.message)
    end

    {
      body: JSON.fast_generate({list: item}),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200,
    }
  end
end
