# frozen_string_literal: true

require 'json'
require 'aws-sdk-dynamodb'
require 'singleton'

class LambdaBase
  include Singleton

  def self.handler(...)
    instance.handler(...)
  end

  def initialize
    @table = Aws::DynamoDB::Table.new(ENV.fetch('KANBAN_TABLE'), Aws::DynamoDB::Client.new)
  end

  def handler(event:, context:)
    raise NotImplementedError
  end

  private

  attr_reader :table
end
