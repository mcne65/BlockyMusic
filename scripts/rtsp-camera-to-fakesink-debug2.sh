#!/usr/bin/env bash

#
# Copyright (c) Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#

set -ex

ROOT_DIR=$(readlink -f $(dirname $0)/..)
LOG_FILE="/tmp/$(basename "${0}" .sh).log"
CAMERA_USER=${CAMERA_USER:-admin}
CAMERA_HOST=${CAMERA_HOST:-192.168.1.102}
export GST_DEBUG="INFO,rtspsrc:LOG,rtpbin:LOG,rtpsession:LOG,rtpjitterbuffer:LOG,rtph264depay:LOG,h264parse:LOG,mpegtsmux:LOG,mpegtsbase:LOG,mpegtspacketizer:LOG,avdec_h264:LOG,videodecoder:LOG,filesink:LOG,basesink:INFO,identity:LOG"

gst-launch-1.0 \
-v \
--eos-on-shutdown \
rtspsrc \
  "location=rtsp://${CAMERA_USER}:${CAMERA_PASSWORD:?Required environment variable not set}@${CAMERA_HOST}/cam/realmonitor?channel=1&subtype=0" \
  buffer-mode=slave \
  ntp-sync=true \
  ntp-time-source= \
  onvif-mode=false \
! identity name=identity-from-rtspsrc silent=false \
! fakesink \
  sync=false \
$* |& tee ${LOG_FILE}
