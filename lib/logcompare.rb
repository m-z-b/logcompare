
# See http://stackoverflow.com/a/735458
dir = File.join(File.dirname(__FILE__),'logcompare','*.rb')
#puts dir
Dir[dir].each do |file|
  #puts "Required #{file}"
  require file
end

