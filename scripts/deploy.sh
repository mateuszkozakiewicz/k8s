#!/bin/sh

set -eu

echo ${CLOUD_KEY} | base64 --decode >${HOME}/key.json

gcloud auth activate-service-account ${CLOUD_ACCOUNT} --key-file=${HOME}/key.json
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io

gcloud components install kubectl
gcloud config set project k8s-free
gcloud container clusters get-credentials k8s-app --region us-central1-b

docker build -t gcr.io/k8s-free/frontend:${TRAVIS_TAG} -f docker/frontend.Dockerfile frontend
docker build -t gcr.io/k8s-free/backend:${TRAVIS_TAG} -f docker/backend.Dockerfile backend

docker push gcr.io/k8s-free/frontend:${TRAVIS_TAG}
docker push gcr.io/k8s-free/backend:${TRAVIS_TAG}

kubectl set image deployment/backend backend=gcr.io/k8s-free/backend:${TRAVIS_TAG} --namespace ${ENV}
kubectl set image deployment/frontend frontend=gcr.io/k8s-free/frontend:${TRAVIS_TAG} --namespace ${ENV}
