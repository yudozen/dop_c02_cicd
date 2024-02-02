include .env
include .env.secret

build:
	docker build \
		--build-arg ORIGINAL_IMAGE_NAME=${ORIGINAL_IMAGE_NAME} \
		-t ${IMAGE_NAME} \
		-f Dockerfile .

version:
	docker run --rm \
		${IMAGE_NAME} \
		version

sh:
	docker run -it --rm --entrypoint sh \
		-v ${PWD}:${MOUNT_DEST} \
		${IMAGE_NAME}

init:
	docker run -it --rm \
		-v ${PWD}/${TARGET_SERVICE}:${MOUNT_DEST} \
		${IMAGE_NAME} \
		init

plan:
	docker run -it --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}/${TARGET_SERVICE}:${MOUNT_DEST} \
		${IMAGE_NAME} \
		plan

apply:
	docker run -it --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}/${TARGET_SERVICE}:${MOUNT_DEST} \
		${IMAGE_NAME} \
		apply

destroy:
	docker run -it --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}/${TARGET_SERVICE}:${MOUNT_DEST} \
		${IMAGE_NAME} \
		destroy
