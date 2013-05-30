class Ranking < ActiveRecord::Base
  validates_uniqueness_of :userid
  attr_accessible :honor, :level, :military, :name, :userid, :winpercentage, :xp
  SORTKEYS = ["xp", "winpercentage", "honor", "military"]

  SORTKEYS.each do |key|

     define_singleton_method "top10_#{key}" do
        userids = $redis.zrevrange(key, 0, 10)
        rankings = []
        userids.each_with_index do |userid,idx|
          ranking = hgetall(userid)
          ranking[:rank] = idx + 1
          rankings.push(ranking)
        end
        rankings
    end

     define_singleton_method "myrank_#{key}" do |userid|
         order = $redis.zrevrank(key, userid)
         count = $redis.zcard(key)
         high = order - 4
         low = order + 5
         high = 0 if high < 0
         low = count-1 if low > count-1

         userids = $redis.zrevrange(key, high, low)
         rankings = []
         userids.each_with_index do |userid,idx|
            ranking = hgetall(userid)
            ranking[:rank] = order - 4 + idx + 1
            rankings.push(ranking)
         end
         rankings
      end

   end

   def self.hgetall(userid)
    ranking = $redis.hgetall(userid)
    ranking[:userid] = userid
    ranking = Ranking.new(ranking)
    ranking.id = ranking.created_at = ranking.updated_at = 1 #set this for editting
    ranking
  end

  def self.save2redis(rankinghash)
      userid = rankinghash.delete(:userid)
      $redis.mapped_hmset(userid, rankinghash)

      Ranking::SORTKEYS.each do |key|
          $redis.zadd(key, rankinghash[key.to_sym], userid)
      end
  end


  def self.destroy2redis(userid)
      $redis.del(userid)
      Ranking::SORTKEYS.each do |key|
          $redis.zrem(key, userid)
      end
  end

end
