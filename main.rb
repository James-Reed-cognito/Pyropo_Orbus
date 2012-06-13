#!/usr/bin/env ruby

require 'socket'
class Bot

  def initialize
    @server = "irc.freenode.net"
    @port = 6667
    @username = "PyropoOrbus"
    @password = "quizclub430"
    @admins = [ "WhereIsMySpoon" ]
    @channels = [ "##p_o_testing" ]
  end
  
  def run
    @irc = TCPSocket.new(@server, @port)
    send("NICK " + @username)
    send("USER WhereIsMySpoon 0 * :WhereIsMySpoon")
    send("PRIVMSG NickServ :identify " + @username + " " + @password)
    sleep 5
    send("JOIN " + @channels.first)
    send("PRIVMSG " + @channels.first + " :Oohai!")
    while line = @irc.gets
      puts line
    end
  end
  
  def send(m)
    @irc.send "#{m}\r\n", 0
  end
  
end

@bot = Bot.new
@bot.run
