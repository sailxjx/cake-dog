default: generate

generate:
	rm -rf lib/*
	coffee -o lib -c src

watch:
	@[ ! -f .coffee.pid ]
	@coffee -w -o lib -c src 2>&1 1>/dev/null & \
	echo $$! > .coffee.pid; \
	if [ $$? -gt 0 ]; then echo "watch error"; else echo "watching"; fi

stop:
	@[ -f .coffee.pid ] && kill $$(cat .coffee.pid) && rm .coffee.pid; \
	    if [ $$? -gt 0 ]; then echo "stop error"; else echo "stoped"; fi

.PHONY: generate
