install:
	sudo ln -sf "$(shell pwd)/bin/deploy" "/usr/bin/deploy"
	sudo ln -sf "$(shell pwd)/var/log" "/var/log/deploy"
