# Version 0.1

FROM alpine:3.2

MAINTAINER Alex Rudd <github.com/AlexRudd/dockopscenter/issues>

#OpsCenter Version
ENV OPSCENTER_VERSION=5.2.2

# Expose ports (WebUI, Agent monitoring port)
EXPOSE 8888 61620

#install full tar
RUN apk add --update tar
RUN apk add --update python

# Download and extract OpsCenter
RUN mkdir -p /opt/opscenter
RUN wget -O - http://downloads.datastax.com/community/opscenter-$OPSCENTER_VERSION.tar.gz \
  | tar xzf - --strip-components=1 -C "/opt/opscenter";

COPY run_opscenter.sh /opt/opscenter/
RUN chmod +x /opt/opscenter/run_opscenter.sh

# Clean up
RUN rm -rf /var/cache/apk/*

#ENTRYPOINT ["/opt/opscenter/run_opscenter.sh"]
CMD ["/bin/sh"]
