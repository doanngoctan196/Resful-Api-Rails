# require 'elasticsearch/model'

class Post < ApplicationRecord
    # include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks
    acts_as_paranoid
    belongs_to :user
    has_many :comments,  dependent: :destroy

    # def self.search(query)
    #     __elasticsearch__.search(
    #       {
    #         query: {
    #           multi_match: {
    #             query: query,
    #             fields: ['title', 'description']
    #           }
    #         }
    #       }
    #     )
    #   end

    def self.search(keywords)
        if keywords
          where("title LIKE ? OR description LIKE ?", "%#{keywords}%", "%#{keywords}%")
        end
end
end
# Post.import force: true 