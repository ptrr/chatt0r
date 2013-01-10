Dir['views/stylesheets/**/*.scss'].select { |f| File.file?(f) }.map { |f| 
  system("sass-convert #{f} #{f.gsub('scss', 'sass')}")
}