#!/bin/bash
set -x

IMAGE_NAME=$1
IMAGE_SHA=$2
REGISTRY_ID=173840052742
ECR_HOST=$REGISTRY_ID.dkr.ecr.us-east-1.amazonaws.com
IMAGE_PATH=$ECR_HOST/$IMAGE_NAME:$IMAGE_SHA

if [ -z "$IMAGE_SHA" ]; then
  IMAGE_ID=$IMAGE_NAME
else
  # auth
  source $HOME/ws/git/awsaccess/oktaawsaccess.sh
  oktaawsaccess clear && oktaawsaccess zimride-developer

  # If using aws CLI version 1.*:
  #`aws ecr get-login --no-include-email --registry-ids $REGISTRY_ID`

  # If using aws CLI version 2.*:
  aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS  --password-stdin $ECR_HOST

  # fetch
  docker pull $IMAGE_PATH

  # find image and run
  IMAGE_ID=`docker images --format "{{.ID}}\t{{.Repository}}:{{.Tag}}" | grep $IMAGE_PATH | cut -f 1`
fi

# To enter as root, add -u 0 to this command
#DEBUG="-p 5005:5005"
docker container run -it --entrypoint /bin/bash $IMAGE_ID
