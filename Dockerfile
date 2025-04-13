# Dockerfile
#FROM debian:12-slim
FROM debian:latest

ENV USERNAME="user" \
    PASSWORD="Passw0rd" \
    SUDO_OK="false" \
    AUTOLOGIN="false" \
    DATA_DIR="/data" \
    TZ="Europe/Berlin"

COPY ./entrypoint.sh /
COPY ./skel/ /etc/skel

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
	ca-certificates \
        curl \
	sudo \
	tini \
	vim && \
    curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.arm -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd && \
    chmod +x /entrypoint.sh && \
    touch /etc/.firstrun && \
    rm /etc/localtime && \
    ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    	apt-transport-https \
	bash-completion \
	bsd-mailx \
	command-not-found \
	dnsutils \
	git \
	htop \
	iproute2 \
	jq \
	less \
	lsof \
	man-db \
	ncdu \
	nullmailer \
	openssh-client \
	procps \
	pwgen \
	rsync  \
	screen \
	tree \
	unzip \
	wget \
	yq \
	zip && \
     apt update

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]

EXPOSE 7681/tcp
