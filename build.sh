#!/bin/bash
for context in $(find . -maxdepth 1 -type d -not -name . -not -name .git | sort); do
	version=$(echo "$context" | cut -c 3-)
	architectures=""
	versiontag="jeanned4rk/ansible:$version"
	while read arch; do
		archtag="$(echo $versiontag-$(echo $arch | sed 's#/#-#g'))"
		echo "Building $archtag" 
		docker build -t "$archtag" --platform="linux/$arch" "$context"
		docker push "$archtag"
		architectures="${architectures} --amend $archtag"
	done < platforms
	docker manifest create "$versiontag" "$architectures"
	docker push "$versiontag"
	read
done

exit 0
