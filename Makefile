.PHONY: vendor all reset-cni
.PHONY: clean clean-bins clean-rootfs clean-image clean-ssh-keys 

VERSION=$(shell git describe --tags --always --dirty)

all:
	go build -o cni-noop ./cmd/cni-noop
	go build -o cnispawn ./cmd/cnispawn
	go build -o kube-spawn-runc ./cmd/kube-spawn-runc
	go build -o kube-spawn \
		-ldflags "-X main.version=$(VERSION)" \
		./cmd/kube-spawn

vendor: | dep
	dep ensure
dep:
	@which dep || go get -u github.com/golang/dep

clean: clean-bins clean-rootfs clean-image clean-ssh-keys
clean-ssh-keys:
	rm -rf ./id_rsa*
clean-bins:
	rm -rf ./{cni-noop,cnispawn,kube-spawn}
clean-rootfs:
	sudo rm -rf kube-spawn-*
clean-image:
	rm -rf rootfs.tar.xz

reset-cni:
	sudo rm -rf /var/lib/cni/networks/mynet
