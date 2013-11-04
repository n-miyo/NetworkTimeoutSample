#!/usr/bin/env ruby

require 'socket'

trap("SIGINT") {exit 0}
def run(port, await, hwait, bwait1, bwait2)
  server = TCPServer.new '0.0.0.0', port

  loop do
    select([server])

    puts "Accepting..."
    sleep await if await != 0
    session = server.accept
    puts "Accept done"

    if request = session.gets
      begin
        puts "Sending header..."
        sleep hwait if hwait != 0
        session.print "HTTP/1.0 200/OK\r\nContent-type:text/plain\r\n\r\n"
        puts "Header done."

        puts "Sending body1..."
        sleep bwait1 if bwait1 != 0
        session.print "hello, world\n"
        puts "Body1 done."

        puts "Sending body2..."
        sleep bwait2 if bwait2 != 0
        session.print "good-bye, world\n"
        puts "Body2 done."
      rescue Exception => e
        puts "Exception: #{e.message}"
      end
    end

    puts "Done."
    session.close
  end
end

if ARGV.length != 5
  STDERR.puts "#{$0}: port accept_wait header_wait body_wait1 body_wait2"
  exit 1
end

run *ARGV.map{|x|x.to_i}

# EOF
