# dockopscenter
[Highly configurable dockerized DataStax OpsCenter](https://hub.docker.com/r/alexrudd/dockopscenter/)

## Description
**Current OpsCenter Version: 5.2.4**

Configure DataStax OpsCenter with custom directive overrides or by specifying the location of an alternate config file.

A full list of configuration options are available from the [DataStax website.](https://docs.datastax.com/en/opscenter/5.1/opsc/configure/opscConfigProps_r.html)

Built on top of alpine linux docker image version 3.3

## Issues

* Fails at "Determining ssh fingerprints of new instances." if deploying into a subnet which doesnt assign public IPs (only private). **This is confirmed to be a bug in OpsCenter that is to be fixed in the next release.**
```
INFO: Node cfdev-0 is now running.
INFO: Ips for cfdev-0 are: None (public), 10.0.30.82 (private)
...
INFO: Determining ssh fingerprints of new instances.
Error determining fingerprints
...
Failure: exceptions.TypeError: sequence item 0: expected string, NoneType found
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
make build tag=<mytag> ver=<opscenterversion>
```

If you don't specify a tag or version, it will default to the latest values already in the Makefile

## Contributing

Pull requests are welcome. Consider creating an issue to discuss the feature before doing the development work, or just fork and create a pull request.
