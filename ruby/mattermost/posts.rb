require 'net/http'
require 'json'
require 'pp'

module Mattermost
        class << self
                @@token = nil

                def login(serverurl, username, password)
                        @@url = URI.parse(serverurl)

                        req = Net::HTTP::Post.new(api_path("/users/login"))
                        req.body = {
                                :login_id => username,
                                :password => password
                        }.to_json

                        res = request(req)

                        @@token = res["Token"]
                        raise "fail to get session token¥n¥n"+res.body unless @@token
                end

                def posts(channel, msg)
                        req= Net::HTTP::Post.new(api_path("/posts"))
                        req.body = {
                                :channel_id => channel,
                                :message => msg
                        }.to_json

                        res = request(req)
                end

                private

                def api_path(path)
                        File.join("/api/v4/", path)
                end

                def request(req)
                        req["Authorization"] = "Bearer #{@@token}" if @@token

                        res = Net::HTTP.start(@@url.host, @@url.port) do |http|
                                http.request(req)
                        end

                        res.value
                        res
                end
        end
end

Mattermost.login("http://localhost:8065", "", "")
Mattermost.posts("ajfm3ffohtfd3rf3uij31zufne", "hello")
