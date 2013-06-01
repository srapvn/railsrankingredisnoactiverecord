# uri = URI.parse(ENV["REDISTOGO_URL"])
# unless $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#    $redis = Redis.new(:host => 'localhost', :port => 6379)
# end

$redis = Redis.new(:host => 'squawfish.redistogo.com', :port => 10098, :password => '712e69263ebaaa8e314d11266c96639e')

unless $redis
   $redis = Redis.new(:host => 'localhost', :port => 6379)
end
