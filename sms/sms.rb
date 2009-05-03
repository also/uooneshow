require 'timeout'
require 'net/http'
require 'uri'

def process_message(filename)
  text = File.new(filename).read
  match = /^Date: (.+)\nFrom: +(.+)\@gnokii.+Subject: [^\n]+\n\n(.+)\n\n\n$/m.match(text)
  if match
    data = {'feed_item[created_at]' => match[1], 'feed_item[from_user]' => match[2], 'feed_item[text]' => match[3], 'feed_item[source]' => 'sms'}
    
    res = Net::HTTP.post_form(URI.parse('http://10.0.100.8:3000/feed_items'), data)
    # TODO remove file
  else
    puts "error"
  end
end


file_prefix = "sms-#{Time.now.to_i}-"
sms_num = 1

while true
  begin
    Timeout::timeout(5) do
      filename = "#{file_prefix}#{sms_num}"
      result = `gnokii --getsms IN 1 -d -f #{filename} 2>&1`
      if result =~ /The given location is empty/
        print '.'
      elsif result =~ /Saving into/
        sms_num += 1
        print '+'
        process_message(filename)
      else
        puts
        puts result
        puts
      end
    end
  rescue Timeout::Error
    print 't'
    # TODO notify connector
  end
  STDOUT.flush
end

