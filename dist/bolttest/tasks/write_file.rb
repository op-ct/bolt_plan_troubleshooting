#!/opt/puppetlabs/bolt/bin/ruby

File.open(ENV['PT_file'], 'w'){ |f| f.puts ENV['PT_content'] }
