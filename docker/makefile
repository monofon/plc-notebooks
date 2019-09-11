plc: plc-base
	docker build --tag=plc plc
	docker tag plc monofon/plc
	docker push monofon/plc

plc-base:
	docker build --tag=plc-base plc-base
	docker tag plc-base monofon/plc-base
	docker push monofon/plc-base

.PHONY: plc-base plc