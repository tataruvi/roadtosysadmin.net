#!/bin/bash

echo $pubkey_base64 | base64 -d - | sha256sum -b - | tr -d " *-" | \
  xargs -I {} printf "4 2 %s" "{}"
