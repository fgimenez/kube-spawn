#!/bin/sh

set -e

echo "kubernetes" | passwd --stdin root

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum -y install \
	docker \
	openssh-server \
	bind-utils \
	ebtables \
	ethtool \
	net-tools \
	socat \
	strace \
	jq \
	less \
	wget \
	iproute \
	util-linux \
	tmux

cat >>/etc/sysconfig/docker <<-EOF
INSECURE_REGISTRY='--insecure-registry=10.22.0.1:5000'
EOF

systemctl daemon-reload || true
systemctl enable docker.service
systemctl enable sshd.service

mkdir -p /etc/kubeadm
cat >/etc/kubeadm/kubeadm.yml <<-EOF
AuthorizationMode: AlwaysAllow
KubernetesVersion: latest
EOF

cat >>/etc/systemd/system/kubelet.service.d/20-kubeadm-extra-args.conf <<-EOF
[Service]
Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=systemd"
EOF
