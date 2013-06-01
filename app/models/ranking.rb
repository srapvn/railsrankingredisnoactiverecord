class Ranking
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  ATTRS_ACCESSIBLE = [:userid, :name, :winpercentage, :level, :xp, :honor, :military]
  attr_accessor *ATTRS_ACCESSIBLE, :rank

  validates_presence_of :name, :userid, :winpercentage, :level, :xp, :honor, :military
  validates_numericality_of :userid, only_integer:true, greater_than_or_equal_to: 0
  validates_numericality_of :winpercentage, greater_than_or_equal_to: 0
  validates_numericality_of :level, only_integer:true, greater_than_or_equal_to: 0
  validates_numericality_of :xp, only_integer:true, greater_than_or_equal_to: 0
  validates_numericality_of :honor, only_integer:true, greater_than_or_equal_to: 0
  validates_numericality_of :military, only_integer:true, greater_than_or_equal_to: 0

  def initialize(attributes = {userid:0, name:nil, winpercentage:0, level:0, xp:0, honor:0, military:0})
    attributes.each do |name, value|
      send("#{name}=", value) if ATTRS_ACCESSIBLE.include? name.to_sym
    end
  end

  def persisted?
    false
  end

  SORTKEYS = ["xp", "winpercentage", "honor", "military"]

  SORTKEYS.each do |key|

     define_singleton_method "top10_#{key}" do
        userids = $redis.zrevrange(key, 0, 10)
        rankings = []
        userids.each_with_index do |userid,idx|
          ranking = hgetall(userid)
          ranking.rank = idx + 1
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
            ranking.rank = order - 4 + idx + 1
            rankings.push(ranking)
         end
         rankings
      end

   end

   def self.hgetall(userid)
    ranking = $redis.hgetall(userid)
    ranking[:userid] = userid
    ranking = Ranking.new(ranking)

    # need to be set for more information if needed
    # ranking.id = ranking.created_at = ranking.updated_at = 1
    ranking
  end

  def self.save2redis(rankinghash)
      ranking = Ranking.new(rankinghash)
      if ranking.valid?
        userid = rankinghash.delete(:userid)
        $redis.mapped_hmset(userid, rankinghash)

        Ranking::SORTKEYS.each do |key|
            $redis.zadd(key, rankinghash[key.to_sym], userid)
        end
      else
        return nil
      end
  end


  def self.destroy2redis(userid)
      $redis.del(userid)
      Ranking::SORTKEYS.each do |key|
          $redis.zrem(key, userid)
      end
  end

end
