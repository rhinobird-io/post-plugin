require 'grape'
require 'active_record'
require 'active_support/all'
require 'grape/activerecord'
require_relative 'models/init'
require_relative 'serializers/init'

module PostApp
  class API < Grape::API
    include Grape::ActiveRecord::Extension
    version 'v1'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    helpers do
      def current_user_id
        env['HTTP_X_USER'].to_i if env['HTTP_X_USER']
      end
      def default_serializer_options
        {root: false}
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      rack_response({error: e.message}.to_json, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      rack_response({error: e.message}.to_json, 400)
    end

    resource :tags do
      get do
        Tag.all
      end

      post do
        Tag.create!({
                        name: params[:name],
                        color: params[:color]
                    })
      end
    end

    resource :posts do
      get '/', each_serializer: SimplePostSerializer do
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
        tags = params[:tags].map{|id| Tag.find(id)}
        Post.create!({
                         creator_id: current_user_id,
                         title: params[:title],
                         body: params[:body],
                         tags: tags
                     })
      end

      get ':id', serializer: CompletePostSerializer do
        Post.find(params[:id])
      end
      params do
        optional :title, type: String, allow_blank: false
        optional :body, type: String
      end
      put ':id' do
        post = Post.find(params[:id])
        if post.creator_id != current_user_id
          rack_response({error: 'Not authorized to modify this post'}.to_json, 401)
        else
          tags = params[:tags].map{|id| Tag.find(id)}
          post.update!({title: params[:title], body: params[:body], tags: tags}.compact)
        end
      end
    end
  end
end