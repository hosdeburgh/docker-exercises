#!/bin/bash

/opt/nexus/bin/nexus start
tail -f /opt/sonatype-work/nexus3/log/nexus.log
