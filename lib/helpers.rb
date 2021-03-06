require 'nanoc-sprockets-filter'

include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::Sprockets

def is_current_item(target)
  item.identifier == target
end

def slider
  items.select {|i| i.identifier =~ /assets\/images\/slider_.+/ }
end