#!/bin/bash

set -e

app="got_quotes_microservice_java"

source './packer/functions.sh'
source './packer/params.sh'

echo creating app in $domain

exist  application ${app} && echo app ${app} already exist || create application ${appParams}
getNextVersion ${app} && deploy ${app} || create autoScaling ${autoScalingParams}
