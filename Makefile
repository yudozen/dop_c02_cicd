include .env
include .env.secret

build:
	docker build \
		--build-arg ORIGINAL_IMAGE_NAME=${ORIGINAL_IMAGE_NAME} \
		--build-arg MOUNT_DEST=${MOUNT_DEST} \
		--build-arg ENTRY_PATH=${ENTRY_PATH} \
		-t ${IMAGE_NAME} \
		-f Dockerfile .

version:
	docker run --rm \
		--entrypoint terraform \
		${IMAGE_NAME} \
		version

sh:
	docker run -it --rm \
		--entrypoint sh \
		${IMAGE_NAME}

plan:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}:${MOUNT_DEST} \
		-w ${MOUNT_DEST}/${ENTRY_PATH} \
		--entrypoint terraform \
		${IMAGE_NAME} \
		plan ${TARGET}

apply:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}:${MOUNT_DEST} \
		-w ${MOUNT_DEST}/${ENTRY_PATH} \
		--entrypoint terraform \
		${IMAGE_NAME} \
		apply ${TARGET}

destroy:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}:${MOUNT_DEST} \
		-w ${MOUNT_DEST}/${ENTRY_PATH} \
		--entrypoint terraform \
		${IMAGE_NAME} \
		destroy ${TARGET}

output:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		-e AWS_REGION="${AWS_REGION}" \
		-v ${PWD}:${MOUNT_DEST} \
		-w ${MOUNT_DEST}/${ENTRY_PATH} \
		--entrypoint terraform \
		${IMAGE_NAME} \
		output