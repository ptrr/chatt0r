system('compass install bootstrap')
puts "[moving folders]"
%w(stylesheets javascripts).each do |folder|
  system("rm -r ./public/#{folder}")
  system("mv -f #{folder} ./public/#{folder}")
end
puts "[done]"
