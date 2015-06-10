require 'bundler/setup'
require 'grape/activerecord/rake'


require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    require './app'
    ActiveRecord::Base.transaction do
      5.times do
        Tag.create!({
                        name: Faker::Commerce.color,
                        color: "rgb(#{Random.rand(255)},#{Random.rand(255)},#{Random.rand(255)})"
                    })
      end
      tags = Tag.all
      60.times do
        Post.create!({
                         title: Faker::Lorem.sentence,
                         body: Faker::Lorem.paragraphs(20).join("\n\n"),
                         creator_id: Random.rand(1..10),
                         tags: tags.sample(Random.rand(1..2))
                     })
      end
    end
  end
end
