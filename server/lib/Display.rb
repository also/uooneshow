require 'socket'

class Display
  def self.send_message(message)
    TCPSocket.open('localhost', 1843) do |s|
      s.print "hi\0"
      s.print "#{message}\0"
    end
  end
end
