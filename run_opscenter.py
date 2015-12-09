#!/usr/bin/env python

import argparse
import os
import pprint
import re
import shutil
import subprocess
import sys

# Location of OpsCenter executable
opscenter_exec = ['/bin/sh', '/opt/opscenter/bin/opscenter', '-f']

# Setup parser
parser = argparse.ArgumentParser(
    description='Build custom config file and start OpsCenter.')

# Option to divert logs to stdout
parser.add_argument(
    "--directives",
    action="store",
    type=str,
    dest="directives",
    help="comma separated list of '[section]option=value,...' directives")
# Option to use configfile in provided location (defaults to
# /opt/opscenter/conf/opscenterd.conf)
parser.add_argument(
    "--configfile",
    action="store",
    type=str,
    dest="configfile",
    help="location of alternate config file to use (overrides --directives)")
# Parse args
args = parser.parse_args()

# Default config
config_location = '/opt/opscenter/conf/opscenterd.conf'
config_dic = {
    'authentication': {
        'enabled': 'False'},
    'webserver': {
        'interface': '0.0.0.0',
        'port': '8888'}}

print "Options:"
print "\t--directives:", args.directives
print "\t--configfile:", args.configfile
print

if args.configfile:
    print "Ignoring directives and using config file:", args.configfile
    src_config = args.configfile
    if os.path.exists(src_config):
        print "copying file:", src_config, "to location:", config_location
        os.remove(config_location)
        shutil.copyfile(src_config, config_location)
    else:
        print "Config file:", args.configfile, "does not exist! Exiting."
        sys.exit(1)

elif args.directives:
    print "No config file specified, using directives:\n\t", args.directives.replace(',', '\n\t')
    print
    print "Provided directives will be merged with the default directives:\n\
        [authentication]enabled=False\n\
        [webserver]interface=0.0.0.0\n\
        [webserver]port=8888"
    print

    # Parse directives and add them to config dictionary
    unparsed_directives = args.directives.split(',')
    for directive in unparsed_directives:
        m = re.match("^\s*\[(.*)\](.*)\=(.*)$", directive)
        config_dic[m.group(1)][m.group(2)] = m.group(3)

    # Delete existing config file
    config_file = open(config_location, 'w')
    config_file.truncate()

    # Write new config file
    print "Writing new config file:"
    for section, options in config_dic.iteritems():
        print "\t[" + section + "]"
        config_file.write("[" + section + "]\n")
        for key, value in options.iteritems():
            print "\t" + key + " = " + value
            config_file.write(key + " = " + value + "\n")

    config_file.close()


else:
    print "No options specified, starting with default configuration"

print "Starting OpsCenter!"
sys.stdout.flush()
# Start subprocess to run OpsCenter
subprocess.call(opscenter_exec)
