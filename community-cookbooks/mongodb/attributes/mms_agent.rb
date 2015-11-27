default['mongodb']['mms_agent']['api_key'] = nil
default['mongodb']['mms_agent']['package_url'] = 'https://mms.mongodb.com/download/agent/%{agent_type}/mongodb-mms-%{agent_type}-agent'

default['mongodb']['mms_agent']['monitoring']['version'] = '2.2.0.70-1'
default['mongodb']['mms_agent']['monitoring']['mmsApiKey'] = node['mongodb']['mms_agent']['api_key']
default['mongodb']['mms_agent']['monitoring']['mmsBaseUrl'] = 'https://mms.mongodb.com'
default['mongodb']['mms_agent']['monitoring']['configCollectionsEnabled'] = true
default['mongodb']['mms_agent']['monitoring']['configDatabasesEnabled'] = true
default['mongodb']['mms_agent']['monitoring']['throttlePassesShardChunkCounts'] = 10
default['mongodb']['mms_agent']['monitoring']['throttlePassesDbstats'] = 20
default['mongodb']['mms_agent']['monitoring']['throttlePassesOplog'] = 10
default['mongodb']['mms_agent']['monitoring']['disableProfileDataCollection'] = false
default['mongodb']['mms_agent']['monitoring']['disableGetLogsDataCollection'] = false
default['mongodb']['mms_agent']['monitoring']['disableLocksAndRecordStatsDataCollection'] = false
default['mongodb']['mms_agent']['monitoring']['enableMunin'] = true
default['mongodb']['mms_agent']['monitoring']['useSslForAllConnections'] = false
default['mongodb']['mms_agent']['monitoring']['sslRequireValidServerCertificates'] = false

default['mongodb']['mms_agent']['backup']['version'] = '2.1.0.106-1'
default['mongodb']['mms_agent']['backup']['mmsApiKey'] = node['mongodb']['mms_agent']['api_key']
default['mongodb']['mms_agent']['backup']['mothership'] = 'api-backup.mongodb.com'
default['mongodb']['mms_agent']['backup']['https'] = true
default['mongodb']['mms_agent']['backup']['sslRequireValidServerCertificates'] = false

default['mongodb']['mms_agent']['user'] = 'mongodb-mms-agent'
default['mongodb']['mms_agent']['group'] = 'mongodb-mms-agent'
