UNAME_S := $(shell uname -s)
LOCAL_PORT ?= 8080
ifeq ($(UNAME_S),Linux)
	LOCAL_ENDPOINT=http://localhost:$(LOCAL_PORT)/vali/api/v1/push
else
	LOCAL_ENDPOINT=http://host.docker.internal:$(LOCAL_PORT)/vali/api/v1/push
endif

.PHONY: build

build:
	sam build

dry-run:
	echo $$(sam local generate-event cloudwatch logs) | sam local invoke LambdaValitailFunction -e - --parameter-overrides ValitailAddress=$(LOCAL_ENDPOINT)
