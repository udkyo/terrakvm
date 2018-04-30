FROM golang:alpine

ENV PACKAGES="wget shadow unzip git pkgconfig libvirt-dev gcc musl-dev nano cdrkit xz qemu-img sudo"
ENV TERRAFORM_VER=0.11.7 \
    DUMB_INIT_VER=1.2.1 \
    LIBVIRT_GO_VER=v4.2.0 \
    TERRAFORM_PROVIDER_LIBVIRT_VER=v0.3

RUN apk add --no-cache $PACKAGES 2>/dev/null || \
    yum install -y $PACKAGES 2>/dev/null || \
    (apt update && apt install -y $PACKAGES) 2>/dev/null || \
    pacman -Syu $PACKAGES --noconfirm 2>/dev/null

RUN wget -qO /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_${DUMB_INIT_VER}_amd64 \
    && chmod +x /usr/local/bin/dumb-init

RUN wget -qO /tmp/tf.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip \
    && unzip /tmp/tf.zip -d /usr/bin \
    && rm -f /tmp/tf.zip \
    && chmod 755 /usr/bin/terraform

RUN go get github.com/libvirt/libvirt-go \
    && go get github.com/dmacvicar/terraform-provider-libvirt

RUN cd $GOPATH/src/github.com/libvirt/libvirt-go \
    && git checkout -b ${LIBVIRT_GO_VER} \
    && go get

RUN cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt \
    && git checkout -b ${TERRAFORM_PROVIDER_LIBVIRT_VER} \
    && go get

RUN cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt  \
    && go install \
    && mkdir -p /home/user/.terraform.d/plugins \
    && mv $GOPATH/bin/terraform-provider-libvirt /home/user/.terraform.d/plugins \
    && mkdir -p /home/user/.cache/libvirt/ \
    && mkdir -p /var/run/libvirt

WORKDIR /terraform

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["dumb-init", "--", "/entrypoint.sh"]
CMD []
