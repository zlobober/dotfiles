#!/bin/bash
for f in \
	chromium \
	opentofu \
	code
do
	snap install --classic $f;
done

