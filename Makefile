check-kubeconfig:
	@test $(KUBECONFIG) || (echo "KUBECONFIG override is not set"; exit 1)

cluster: check-kubeconfig
	k3d cluster get k3s-default || k3d cluster create --port 8080:80@loadbalancer --k3s-arg "--no-deploy=traefik@server:*" --k3s-arg "--kube-apiserver-arg=feature-gates=ServerSideApply=false@server:*" --wait

apply:
	helmfile apply

diff:
	helmfile diff

start: check-kubeconfig cluster apply

restart: destroy start

destroy:
	k3d cluster delete