from __future__ import print_function
import json
import os
import urllib

import collectd

DOCKER_HOST = os.environ.get('DOCKER_HOST', 'tcp://127.0.0.1:4243')


def _read_pct_data_used(host=DOCKER_HOST):
    info = json.load(
        urllib.urlopen('{}/info'.format(host.replace('tcp://', 'http://')))
    )
    driver_status = dict(info['DriverStatus'])
    data_total = float(driver_status['Data Space Total'].split()[0])
    data_used = float(driver_status['Data Space Used'].split()[0])
    return data_used / data_total


def read(data=None):
    val = collectd.Values(type='gauge')
    val.plugin = 'docker_lvm.data_pct_used'
    val.dispatch(values=[_read_pct_data_used()])


def write(val, data=None):
    for value in val.values:
        print('{} ({}): {}'.format(val.plugin, val.type, value))


collectd.register_read(read)
collectd.register_write(write)
