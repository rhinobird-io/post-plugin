require 'grape'
require 'active_record'
require 'active_support/all'
require 'grape/activerecord'
require_relative 'models/init'

module PostApp
  class API < Grape::API
    include Grape::ActiveRecord::Extension
    version 'v1'
    format :json

    helpers do
      def current_user_id
        env['HTTP_X_USER'].to_i if env['HTTP_X_USER']
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      rack_response({error: e.message}.to_json, 404)
    end

    resource :posts do
      get do
        before = params[:before]
        if before.nil?
          Post.limit(20)
        else
          Post.where('id < ?', before).limit(20)
        end
      end

      params do
        requires :title, type: String, allow_blank: false
        requires :body, type: String
      end
      post do
        Post.create!({
                         creator_id: current_user_id,
                         title: params[:title],
                         body: params[:body]
                     })
      end

      route_param :id do
        get do
          Post.find(params[:id])
        end
        params do
          optional :title, type: String, allow_blank: false
          optional :body, type: String
        end
        put do
          post = Post.find(params[:id])
          if post.creator_id != current_user_id
            rack_response({error: 'Not authorized to modify this post'}.to_json, 401)
          else
            post.update!({title: params[:title], body: params[:body]}.compact)
          end
        end
      end
    end
  end
end