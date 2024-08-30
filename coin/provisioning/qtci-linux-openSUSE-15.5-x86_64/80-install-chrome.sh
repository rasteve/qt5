#!/usr/bin/env bash
# Copyright (C) 2022 The Qt Company Ltd.
set -ex

# This script will install up-to-date google Chrome needed for Webassembly auto tests.

# shellcheck source=../common/unix/DownloadURL.sh
source "${BASH_SOURCE%/*}/../common/unix/SetEnvVar.sh"

# shellcheck source=../common/unix/DownloadURL.sh
source "${BASH_SOURCE%/*}/../common/unix/DownloadURL.sh"

# Webassembly auto tests run requires latest Chrome. Let's use the latest stable one which means we can't cache this
sudo zypper ar http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome

# Add the Google public signing key
externalUrl="https://dl.google.com/linux/linux_signing_key.pub"
Download "$externalUrl" "/tmp/linux_signing_key.pub"
sudo rpm --import /tmp/linux_signing_key.pub

# Update the repo cache of zypper and install Chrome
sudo zypper ref -f
sudo zypper -nq install --no-confirm google-chrome-stable

# Install Chromedriver Chromium
sudo zypper -nq install chromedriver

chromeVersion="chrome-for-testing-115"
sha="7242ece1055bdbf503527f8e87c4b5da37c3c60e"
chromeUrl="https://ci-files01-hki.ci.qt.io/input/wasm/chrome/${chromeVersion}.tar.gz"
target="/tmp/chrome-for-testing-115.tar.gz"

DownloadURL "$chromeUrl" "" "$sha" "$target"
sudo tar -xzf "$target" -C "${HOME}"
sudo rm -f "$target"

SetEnvVar "BROWSER_FOR_WASM" "${HOME}/${chromeVersion}/chrome"
SetEnvVar "CHROMEDRIVER_PATH" "${HOME}/${chromeVersion}/chromedriver"
