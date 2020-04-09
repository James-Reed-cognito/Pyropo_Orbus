#!/usr/bin/env ruby

require 'socket'
require 'open-uri'
require 'pp'

class Bot

  def initialize
    @server = "irc.freenode.net"
    @port = 6667
    @username = "PyropoOrbus"
    @password = ""
    @admins = [ "WhereIsMySpoon" ]
    @channels = [ "##p_o_testing" ]
  end
  
  def run
    @irc = TCPSocket.new(@server, @port)
    send("NICK " + @username)
    send("USER WhereIsMySpoon 0 * :WhereIsMySpoon")
    send("PRIVMSG NickServ :identify " + @username + " " + @password)
    sleep 20
    @channels.each { |chan| send("JOIN " + chan) }
    send("PRIVMSG " + @channels.first + " :ohai!")
    while line = @irc.gets
      puts line
      deal_with_input(line)
    end
  end
  
  def send(m)
    @irc.send "#{m}\r\n", 0
  end
  
  #Respond to !quit
  def quit(line)
    channel = get_input_channel(line) #Get the channel that the !quit command was sent from
    user = get_input_sender(line) #Get the user that sent the !quit command
    if line =~ /.*\!quit.*/ and @admins.include?(user)
      send("PRIVMSG " + channel + " :Goodbye!")
      exit 0
    end
  end
  
  def deal_with_input(line)
    server_stuff(line)
    quit(line)
    give_youtube_description(line)
  end
  
  def get_input_channel(line)
    channel_input_sent_from = line.gsub(/.*PRIVMSG/, '').gsub(/\:.*/, '').strip
  end
  
  def get_input_sender(line)
    user = line.gsub(/\!.*/, '').gsub(/\!/, '').gsub(/\:/, '').strip
  end
  
  #Respond to PING
  def server_stuff(line)
    if line =~ /PING :.*\.freenode\.net/
      send("PONG")
    end
  end
    
  def give_youtube_description(line)
    channel = get_input_channel(line)
    if line =~ /.*youtube.com.*/
      url = line.gsub(/.*\:/, '').gsub(/.*youtube/, 'youtube').strip.gsub(/\ .*/, '')
      puts url
      begin
        uri = URI.parse("http://www." + url)
        page = open(uri)
        contents = page.read.gsub(/.*meta name="keywords" content="/m, '').gsub(/".*/m, '').strip
        puts channel + " " + url + " " + contents
        send("PRIVMSG " + channel + " :http://www." + url + " " + contents)
      rescue OpenURI::HTTPError => error
        pp error
        send("PRIVMSG " + channel + " :This video does not exist.")
      end
    end
  end
  
  def get_and_send_file(line)
    if line =~ /.*:\!getfile.*/
      user = get_input_sender(line)
      filename = line.gsub(/.*:\!getfile/, '').strip
      
    end
  end
  
end

@bot = Bot.new
@bot.run
