NAME = gluetun-qbittorrent-port-manager
VERSION = `cat version`

build: Dockerfile start.sh
	docker build -t $(NAME):latest --label "version=$(VERSION)" .

push: Dockerfile start.sh version .secret
	cat .secret | docker login -u snoringdragon --password-stdin
	docker tag $(NAME):latest snoringdragon/$(NAME):$(VERSION)
	docker push snoringdragon/$(NAME):$(VERSION)
	docker tag $(NAME):latest snoringdragon/$(NAME):latest
	docker push snoringdragon/$(NAME):latest
