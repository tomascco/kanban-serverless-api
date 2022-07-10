# frozen_string_literal: true

require 'securerandom'
require 'aws-sdk-s3'
require_relative 'lambda_base'

NOT_FOUND = {
  headers: {'Content-Type' => 'application/json'},
  statusCode: 404
}.freeze


class UploadAttachmentToCard < LambdaBase
  def handler(event:, context:)
    username = event.dig('requestContext', 'authorizer', 'claims', 'cognito:username')

    list_uuid = event.dig('pathParameters', 'listUUID')
    card_uuid = event.dig('pathParameters', 'cardUUID')

    result = table.get_item({
      key: {
        'User' => username,
        'ListsAndCardsCollection' => "#{list_uuid}##{card_uuid}"
      }
    })

    return NOT_FOUND if result.item.nil?

    key = "#{username}/#{card_uuid}/#{SecureRandom.uuid}"
    signed_upload_url = bucket.object(key).presigned_url(:put)

    {
      body: JSON.fast_generate({upload_url: signed_upload_url}),
      headers: {'Content-Type' => 'application/json'},
      statusCode: 200
    }
  end

  private

  def bucket
    @bucket ||= Aws::S3::Resource.new.bucket(ENV['BUCKET_NAME'])
  end
end
