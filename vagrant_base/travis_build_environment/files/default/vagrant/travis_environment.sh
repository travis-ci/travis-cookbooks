export CI=true
export TRAVIS=true

# without this magic variable, nothing can possibly work. MK.
export HAS_JOSH_K_SEAL_OF_APPROVAL=true

export RAILS_ENV=test
export MERB_ENV=test
export RACK_ENV=test

export JRUBY_OPTS="--server"