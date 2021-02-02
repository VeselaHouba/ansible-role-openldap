import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_ldap_is_listening(host):
    ldap = host.socket('tcp://636')
    assert ldap.is_listening


def test_ldap_service_is_running(host):
    with host.sudo():
        assert host.service('slapd.service').is_enabled
        assert host.service('slapd.service').is_running


def test_ldap_cron(host):
    cronfile = host.file("/etc/cron.d/ldap_archive")
    assert cronfile.exists
    assert cronfile.contains('/usr/bin/db_archive')
    assert cronfile.contains('20 2')
