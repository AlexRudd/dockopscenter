# dockopscenter
Highly configurable dockerized DataStax OpsCenter

## Description
**Current OpsCenter Version: 5.2.2**

Configure DataStax OpsCenter with custom directive overrides or by specifying the location of an alternate config file.

A full list of configuration options are available from the [DataStax website.](https://docs.datastax.com/en/opscenter/5.1/opsc/configure/opscConfigProps_r.html)

## Issues

* Fails at "Determining ssh fingerprints of new instances." when using OpsCenter to create new cluster. Traceback:
```
2015-12-09 18:57:50+0000 [] Error determining fingerprints
Traceback (most recent call last):
Failure: exceptions.TypeError: sequence item 0: expected string, NoneType found
2015-12-09 18:57:50+0000 [] ERROR: Fingerprint Detection failed: sequence item 0: expected string, NoneType found sequence item 0: expected string, NoneType found
File "/opt/opscenter/lib/py-debian/2.7/amd64/twisted/internet/defer.py", line 1018, in _inlineCallbacks
result = result.throwExceptionIntoGenerator(g)
File "/opt/opscenter/lib/py-debian/2.7/amd64/twisted/python/failure.py", line 349, in throwExceptionIntoGenerator
return g.throw(self.type, self.value, self.tb)
File "build/lib/python2.7/site-packages/opscenterd/cloud/Ec2Launcher.py", line 582, in _determine_fingerprints
File "/opt/opscenter/lib/py-debian/2.7/amd64/twisted/internet/defer.py", line 1018, in _inlineCallbacks
result = result.throwExceptionIntoGenerator(g)
File "/opt/opscenter/lib/py-debian/2.7/amd64/twisted/python/failure.py", line 349, in throwExceptionIntoGenerator
return g.throw(self.type, self.value, self.tb)
File "build/lib/python2.7/site-packages/opscenterd/SecureShell.py", line 148, in get_remote_ssh_key_map
File "/opt/opscenter/lib/py-debian/2.7/amd64/twisted/internet/defer.py", line 1020, in _inlineCallbacks
result = g.send(result)
File "build/lib/python2.7/site-packages/opscenterd/SecureShell.py", line 370, in _get_remote_ssh_keys_in_bulk
```
* See the following warnings at start-up, not sure if these are actual problems:
```
WARN: Unable to import SSL, further definition actions will fail.
WARN: No http agent exists for definition file update.  This is likely due to SSL import failure.
```

## Usage

There are two ways to insert custom config into the running container, with the `--directives` flag, or the `--configfile` flag.

The `--directives` flag takes a comma separated list of directives which specify the section, option, and value of the config option to be set. These directives will be merged with the default configuration, seen at the bottom of this section.

```
  --directives "[section]option=value,[section]option=value,..."
```

The `--configfile` flag takes the path to a file within the container which will be copied to the OpsCenter's default config location. If this flag is specified, then any custom directives will be ignored.

```
  --configfile "/my_config.file"
```

If neither of these flags is specified, then OpsCenter will be run with the default configuration:
```
[authentication]
enabled = False
[webserver]
interface = 0.0.0.0
port = 8888
```

## Examples

Running container with custom directive overrides

```
docker run --rm -p 80:80 alexrudd/dockopscenter --directives "[webserver]port=80"
```

Running the container with a custom config file location

```
docker run --rm -p 80:80 -v $(pwd)/my_config.file:/my_config.file alexrudd/dockopscenter:0.2 --configfile "/my_config.file"
```

## Build

To change the version of OpsCenter being used by the container, update or override the `OPSCENTER_VERSION` ARG variable:

```
docker build --build-arg OPSCENTER_VERSION=5.2.1 .
```

There's also Makefile included for certain convenience methods including building:

```
make build
```

## Contributing

Pull requests are welcome. Consider creating an issue to discus the feature before doing the development work, or just fork and create a pull request.
