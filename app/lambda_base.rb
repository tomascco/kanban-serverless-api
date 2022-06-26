# frozen_string_literal: true

require 'json'
require 'aws-sdk-dynamodb'
require 'singleton'

class LambdaBase
  include Singleton

  def self.handler(...)
    instance.handler(...)
  end

  def handler(event:, context:)
    raise NotImplementedError
  end

  private

  def table_name
    raise NotImplementedError
  end

  def table
    @table ||= Aws::DynamoDB::Table.new(table_name, Aws::DynamoDB::Client.new)
  end
end
