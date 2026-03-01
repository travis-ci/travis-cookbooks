# frozen_string_literal: true

default['travis_duo']['user'] = 'sshd'
default['travis_duo']['group'] = 'root'
default['travis_duo']['conf']['ikey'] = ''
default['travis_duo']['conf']['skey'] = ''
default['travis_duo']['conf']['host'] = ''
default['travis_duo']['conf']['failmode'] = 'safe'
