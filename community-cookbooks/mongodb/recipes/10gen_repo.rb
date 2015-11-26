Chef::Log.warn('10gen_repo is deprecated, use mongodb_org_repo')
include_recipe 'mongodb::mongodb_org_repo'
