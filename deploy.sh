#!/bin/sh
set -e

if [ "$#" -ne 1 ]
then
  echo "Usage: deploy <production|staging>"
  exit 1
fi

_environment="$1"

if [ "$_environment" = "production" ]; then
  mix edeliver build release
  mix edeliver deploy release to production
  mix edeliver restart production
  mix edeliver migrate production
  mix edeliver restart production
  mix edeliver ping production
fi

if [ "$_environment" = "staging" ]; then
  mix edeliver build release --branch=staging --mix-env=staging
  mix edeliver deploy release to staging --mix-env=staging
  mix edeliver restart staging --mix-env=staging
  mix edeliver migrate staging --mix-env=staging
  mix edeliver restart staging --mix-env=staging
  mix edeliver ping staging --mix-env=staging
fi
