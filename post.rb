require 'grape'
require 'active_record'

module Post
  class API < Grape::API
    version 'v1', using: :header, vendor: 'rhinobird_post'
    format :json
    prefix :api

    resource :posts do
      get do
        {text: "hello world"}
      end
    end
  end
end