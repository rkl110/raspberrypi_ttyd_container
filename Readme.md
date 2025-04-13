podman run --rm -p 7681:7681 debian-ttyd
podman run --rm -p 8080:8080 debian-ttyd

podman build -t debian-ttyd .


podman run --rm -p 7681:7681 --env-file=.env debian-ttyd

sudo cp podman_ttyd.service /etc/systemd/system/podman_ttyd.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now podman_ttyd.service

sudo loginctl enable-linger admina
