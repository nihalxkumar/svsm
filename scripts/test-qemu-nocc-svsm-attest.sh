#!/bin/bash
# SPDX-License-Identifier: MIT
#
# Copyright (c) 2026 Coconut-SVSM Authors
#
# Author: Coconut-SVSM CI

set -u

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# When we see this string on the serial output, consider
# SVSM booted and attestation test passed.
SUCCESS="Attestation test passed"

# Fail the test after this timeout.
TIMEOUT=240s

# Clone STDOUT for live log reporting.
exec 3>&1

echo "================================================================================"
timeout $TIMEOUT \
  grep -q -m 1 "$SUCCESS" \
  <("$SCRIPT_DIR/test-in-svsm-attest.sh" --nocc </dev/null 2>&1 | tee /proc/self/fd/3)
RES=$?
echo "================================================================================"

case $RES in
0)
  echo "Test Pass!"
  exit 0
  ;;
124)
  echo "Test failed: timeout"
  exit 1
  ;;
*)
  echo "Test failed: Unknown error"
  exit 1
  ;;
esac
