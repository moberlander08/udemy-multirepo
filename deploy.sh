#buld the docker images 
#(docker image build -t tag_name -f path/dockerfile ./build_context)
docker image build -t moberlander08/multi-client:latest -t moberlander08/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker image build -t moberlander08/multi-server:latest -t moberlander08/multi-client:$GIT_SHA -f ./server/Dockerfile ./server
docker image build -t moberlander08/multi-worker:latest -t moberlander08/multi-client:$GIT_SHA -f ./worker/Dockerfile ./worker

#Push images to docker hub
docker push moberlander08/multi-client:latest
docker push moberlander08/multi-server:latest
docker push moberlander08/multi-worker:latest

docker push moberlander08/multi-client:latest:$GIT_SHA
docker push moberlander08/multi-server:latest:$GIT_SHA
docker push moberlander08/multi-worker:latest:$GIT_SHA


#apply k8s configs
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=moberlander08/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=moberlander08/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=moberlander08/multi-worker:$GIT_SHA