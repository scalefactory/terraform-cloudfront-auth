SHELL := /bin/bash

export README_TEMPLATE_FILE ?= $(BUILD_HARNESS_PATH)/templates/ScaleFactory.README.md

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)
-include $(shell curl -sSL -o build-harness/templates/ScaleFactory.README.md "https://gist.githubusercontent.com/StevePorter92/458c4be42b1238f7c8f203bf17cc7fd1/raw/2837b336972150d556cff2fdd8464c7d352051fe/README.md")
