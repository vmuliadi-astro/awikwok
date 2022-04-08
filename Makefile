#!/usr/bin/make -f
BREW:=/opt/homebrew/bin/brew""
JQ:="/opt/homebrew/bin/jq"
LIMA:="/opt/homebrew/bin/lima"
LIMACTL:="/opt/homebrew/bin/limactl"
TEMPLATE_FILE:=$(CURDIR)/ubuntu-x86_64.yaml
INSTANCE_NAME:="ubuntu-x86_64"

create:
	echo | $(LIMACTL) start $(TEMPLATE_FILE)
	$(LIMACTL) shell $(INSTANCE_NAME) uname -a
	$(LIMA) nerdctl run hello-world:latest

	echo "====================================="
	echo "PLEASE ADD THIS TO YOUR SHELL PROFILE"
	echo "alias docker='"$(LIMA)" nerdctl'"
	echo "====================================="

	echo "Checking container architecture for newly pull-ed image"
	$(LIMA) nerdctl inspect hello-world | $(JQ) .[0].Architecture | tr -d '"'

destroy:
	$(LIMACTL) stop $(INSTANCE_NAME) || true
	$(LIMACTL) delete $(INSTANCE_NAME)
	echo "instance has been destroyed"

init:
	$(BREW) install lima
	$(BREW) install jq
