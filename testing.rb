#!/usr/bin/env ruby

require 'open-uri'

def give_youtube_description(line)
  #channel = get_input_channel(line)
  if line =~ /.*youtube.com.*/
    url = line.gsub(/.*\:/, '').gsub(/.*youtube/, 'youtube').strip.gsub(/\ .*/, '')
    puts url
    page = open("http://www." + url)
    contents = page.read.gsub(/.*meta name="keywords" content="/m, '').gsub(/".*/m, '').strip
    #puts contents
    #send("PRIVMSG " + channel + " " + url + " - " + contents)
    contentfile = open("ytfile.txt", "r+")
    contentfile.puts(contents)
  end
end

give_youtube_description("http://www.youtube.com/watch?v=uOR8t1UVJ4c")
