#!/bin/bash
for context in $(find . -maxdepth 1 -type d -not -name . -not -name .git | sort); do
	version=$(echo "$context" | cut -c 3-)
	architectures=""
	versiontag="jeanned4rk/ansible:$version"
	while read arch; do
		echo "Building $version:$arch"
		archtag="$versiontag-$arch"
		docker build -t "$archtag" --build-arg ARCH="$arch/" "$context"
		docker push "$archtag"
		architectures="${architectures} --amend $archtag"
	done < "$context/platforms"
	docker manifest create "$versiontag" "$architectures"
	docker push "$versiontag"
done

exit 0
