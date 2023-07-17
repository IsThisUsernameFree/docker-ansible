#!/bin/bash

docker buildx create --use --platform=linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/adm64 --name multi-platform-builder > /dev/null

docker buildx inspect --bootstrap

if [ "$?" -ne 0 ]; then
	echo "Error occured while creating multi platform builder"
	exit 1
fi

for context in $(find . -maxdepth 1 -type d -not -name . -not -name .git); do
	version=$(echo "$context" | cut -c 3-)
	echo "Building $version"
	docker builx build -push --platform $(cat "$context/platforms") --tag "jeanned4rk/ansible:$version" "$context"
done

exit 0
