#!/bin/bash
# Enter a docker image, either by name and sha or by image id

if [ "$1" == "-h" ] || [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <image_name> <sha> - fetch and enter a remote image"
  echo "       $0 <image_id>         - enter a locally cached image"
  echo "  To enable debugging, set DEBUG_PORT=<port>. To enter as root, set AS_ROOT=true"
  echo "Examples:"
  echo "  $ image_run.sh javalyfthellolib 423f3b5d4d6c2109d4e5a0b8406f3e49dcf1377a"
  echo "  $ image_run.sh c056c85df8b1"
  exit
fi

set -x
IMAGE_NAME=$1
IMAGE_SHA=$2
REGISTRY_ID=173840052742
ECR_HOST=$REGISTRY_ID.dkr.ecr.us-east-1.amazonaws.com
ECR_PATH=`echo $IMAGE_NAME | sed "s/-//g"`
IMAGE_PATH=$ECR_HOST/$ECR_PATH:$IMAGE_SHA

if [ -n "$AS_ROOT" ]; then
  ROOT_ARG="-u 0"
fi

if [ -n "$DEBUG_PORT" ]; then
  DEBUG_ARG="-p $DEBUG_PORT:$DEBUG_PORT"
fi

if [ -z "$IMAGE_SHA" ]; then
  IMAGE_ID=$IMAGE_NAME
else
  # auth requires https://github.com/lyft/awsaccess
  if [ ! -f "$HOME/src/awsaccess/oktaawsaccess.sh" ]; then
      echo 'ERROR: This script requires https://github.com/lyft/awsaccess cloned out at $HOME/src'
      exit 1
  fi
  source $HOME/src/awsaccess/oktaawsaccess.sh
  oktaawsaccess clear && oktaawsaccess zimride-developer

  AWS_VERSION=`aws --version | sed 's:aws-cli/::'`
  if [[ $AWS_VERSION == 1* ]]; then
    # If using aws CLI version 1.*:
    `aws ecr get-login --no-include-email --registry-ids $REGISTRY_ID`
  else
    # If using aws CLI version 2.*:
    aws ecr get-login-password --region us-east-1 | \
      docker login --username AWS  --password-stdin $ECR_HOST
  fi

  # fetch
  docker pull $IMAGE_PATH

  # find image and run
  IMAGE_ID=`docker images --format "{{.ID}}\t{{.Repository}}:{{.Tag}}" | grep $IMAGE_PATH | cut -f 1`
fi

docker container run -it $ROOT_ARG $DEBUG_ARG --entrypoint /bin/bash $IMAGE_ID
