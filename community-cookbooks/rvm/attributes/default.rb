# Default to mainline Ruby, available are:
# [ 'ruby', 'jruby', 'rbx', 'ree', 'macruby', 
#   'maglev', 'ironruby', 'mput', 'system' ]
#
# see:
#   http://rvm.beginrescueend.com/interpreters/
# default[:rvm][:ruby][:implementation] = 'ruby'
# most people default to 1.8.7 still
# even if I prefer 1.9.2.
# default[:rvm][:ruby][:version] = '1.8.7'
# set the default patch level
# default[:rvm][:ruby][:patch_level] = 'p302'

# Use either :stable or :head versions of
# RVM.
default[:rvm][:version] = :stable
# Keep track of updates to RVM.
# note: this will effectively inhibit
# installation of :head.
default[:rvm][:track_updates] = false
