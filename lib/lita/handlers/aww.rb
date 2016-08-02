require 'json'
require 'net/http'

module Lita
  module Handlers
    class Aww < Handler
      # insert handler code here
      route(/^echo\s+(.+)/) do |response|
        http = Net::HTTP.new('www.reddit.com')
        response = http.request(Net::HTTP::Get.new("/r/aww.json"))
        json = JSON.parse(response.body)

        if json['data']['children'].count <= 0
          send_event('aww', image: placeholder)
        else
          urls = json['data']['children'].map{|child| child['data']['url'] }

          # Ensure we're linking directly to an image, not a gallery etc.
          valid_urls = urls.select{|url| url.downcase.end_with?('png', 'gif', 'jpg', 'jpeg')}
          send_event('aww', image: "background-image:url(#{valid_urls.sample(1).first})")
        end

      end

      Lita.register_handler(self)
    end
  end
end
