all: apply-secret apply-services apply-controllers get-services get-controllers

apply-namespace:
	kubectl apply -f trillo-namespace.yaml
	kubectl get namespaces trillo

apply-secret: apply-namespace
	kubectl apply -f trillo-secrets.yaml
	@#kubectl -n trillo create secret docker-registry --docker-username=trilloci --docker-password='<PASSWORD>' trillo-dockerhub-secret

get-secret:
	kubectl get -f trillo-secrets.yaml

apply-services:
	kubectl apply -f trillo-rt-service.yaml
	kubectl apply -f trillo-ds-service.yaml

get-services:
	kubectl get -f trillo-rt-service.yaml
	kubectl get -f trillo-ds-service.yaml

apply-volumes: apply-namespace
	kubectl apply -f trillo-persistent-volumes.yaml

delete-volumes:
	kubectl delete -f trillo-persistent-volumes.yaml

get-volumes:
	kubectl get -f trillo-persistent-volumes.yaml

apply-controllers: apply-secret apply-volumes
	kubectl apply -f trillo-rt-controller.yaml
	kubectl apply -f trillo-ds-controller.yaml

get-controllers:
	kubectl get -f trillo-rt-controller.yaml
	kubectl get -f trillo-ds-controller.yaml
	kubectl -n trillo get pods

delete-controllers:
	kubectl delete -f trillo-rt-controller.yaml
	kubectl delete -f trillo-ds-controller.yaml

rollout-status:
	@kubectl rollout status -f trillo-rt-controller.yaml
	@kubectl rollout status -f trillo-ds-controller.yaml
	@kubectl rollout history -f trillo-rt-controller.yaml
	@kubectl rollout history -f trillo-ds-controller.yaml

#update-images:
#	kubectl -n trillo set image deployment trillo-rt trillo-rt=trillo/trillo-rt:1.0.0-BUILD-SNAPSHOT_207
#	kubectl -n trillo set image deployment trillo-ds trillo-ds=trillo/trillo-data-service:0.5.0-BUILD-SNAPSHOT_81

rollout-undo:
	@kubectl rollout undo -f trillo-rt-controller.yaml
	@kubectl rollout undo -f trillo-ds-controller.yaml

create-autoscale:
	kubectl autoscale -f trillo-rt-controller.yaml --max=20 --cpu-percent=75
	kubectl autoscale -f trillo-ds-controller.yaml --max=20 --cpu-percent=75

delete-autoscale:
	kubectl delete horizontalpodautoscalers.autoscaling trillo-rt
	kubectl delete horizontalpodautoscalers.autoscaling trillo-ds

delete-namespace: delete-controllers delete-volumes
	kubectl delete -f trillo-namespace.yaml
