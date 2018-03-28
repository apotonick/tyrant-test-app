class User < ApplicationRecord
  serialize :auth_data, JSON
end
