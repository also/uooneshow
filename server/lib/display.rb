require 'socket'

class Display
  def self.send_message(message)
    begin
    TCPSocket.open('localhost', 1843) do |s|
      s.print "hi\0"
      s.print "#{message}\0"
    end
    rescue Errno::ECONNREFUSED => ex
      # TODO log error
    end
  end
end
