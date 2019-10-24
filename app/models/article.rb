class Article < ApplicationRecord
  belongs_to :user
  # is_impressionable counter_cache: true

  def update_score
    REDIS.zincrby "ranking", 1, self.id
  end

  def score
    REDIS.zscore "ranking", self.id
  end
end
