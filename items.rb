#!/usr/bin/env ruby
# coding: utf-8

# bundle install --standalone
require_relative "bundle/bundler/setup"
require "qiita"

query = ARGV[0]
client = Qiita::Client.new(access_token: ENV['token'], host: ENV['host'])

response = client.get("/api/#{ENV['api_version']}/items", per_page: 20, query: query)
return if response.body.nil?

items = response.body.map do | res |
  tags = (res["tags"].map do | tag | tag["name"] end).join(',')
  subtitle =  "@#{res['user']['id']} / #{tags}"
  {
    uid: res["id"],
    title: res["title"],
    subtitle: subtitle,
    arg: res["url"],
    quicklookurl: res["url"] 
  }
end

print({items: items}.to_json)
