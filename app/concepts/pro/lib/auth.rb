module Pro::Lib
  require "dry/struct"
  module Types
    include Dry::Types.module
  end

  class Auth < Dry::Struct::Value
    constructor_type :strict_with_defaults # TODO: remove me when failed_logins etc is sorted

    attribute :password_digest, Types::Strict::String
    attribute :state,           Types::Strict::String # FIXME.
    attribute :timestamp,       Types::Json::Time
    attribute :expires_at,      Types::Json::Time

    # FIXME
    attribute :failed_logins, Types::Int.default(0)
  end
end
