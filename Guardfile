require 'fileutils'

guard 'bundler' do
  watch('Gemfile')
end

guard 'nanoc' do
  watch('nanoc.yaml')
  watch('Rules')
  watch(%r{^(content|layouts|lib|config|vendor)/.*$})

  callback(:start_begin)   { FileUtils.rm_rf File.join(File.dirname(File.expand_path(__FILE__)), 'public') }
  callback(:run_all_begin) { FileUtils.rm_rf File.join(File.dirname(File.expand_path(__FILE__)), 'public') }
end

guard 'livereload' do
  watch(%r{public/.+\.()$})
end

