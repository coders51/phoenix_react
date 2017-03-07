#!/bin/sh
set -e

mix edeliver build release --skip-git-clean --skip-mix-clean
mix edeliver deploy release to production
mix edeliver restart production
mix edeliver migrate production
mix edeliver restart production
mix edeliver ping production
