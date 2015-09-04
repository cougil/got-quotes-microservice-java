#!/usr/bin/env bash
set -e
echo "Branch: ${TRAVIS_BRANCH}"

if [ -z "${AWS_ACCESS_KEY+xxx}" ]; then echo "AWS_ACCESS_KEY is not set at all";i exit 1; fi
if [ -z "AWS_ACCESS_KEY" -a "${AWS_ACCESS_KEY+xxx}" = "xxx" ]; then echo "AWS_ACCESS_KEY is set but empty"; exit 1; fi
if [ -z "${AWS_SECRET_KEY+xxx}" ]; then echo "AWS_SECRET_KEY is not set at all"; exit 1;fi
if [ -z "AWS_SECRET_KEY" -a "${AWS_SECRET_KEY+xxx}" = "xxx" ]; then echo AWS_SECRET_KEY is set but empty;exit 1; fi

export creator=$(git --no-pager show -s --format='%ae' ${TRAVIS_COMMIT})
export creation_time=`date +"%Y%m%d%H%M%S"`
export appversion="0.0.${TRAVIS_BUILD_ID}"
export ec2_source_ami=ami-a10897d6

CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Building Packer....with common file=$1"

echo "CWD ${CWD}"
$CWD/install-packer.sh

packer -machine-readable build -var version=${TRAVIS_BRANCH} $1 | sudo tee output.txt
tail -2 output.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }' >  ami.txt

