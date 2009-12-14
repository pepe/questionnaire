require 'ftools'
src = File.join(File.dirname(__FILE__), "deploy.rb.sinatra")
dest = File.join(File.dirname(__FILE__), "..", "..", "..", "config", "deploy.rb")
File.copy src, dest unless File.exists?(dest)
