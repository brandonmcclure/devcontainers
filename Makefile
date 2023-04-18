ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command


.PHONY: all clean test lint act
all: test
# Act/github workflows
ACT_ARTIFACT_PATH := /workspace/.act 
act: act_MegaLinter act_validateLFS act_buildDockerImage 
act_MegaLinter:
	act -j MegaLinter --artifact-server-path $(ACT_ARTIFACT_PATH)
act_validateLFS:
	act -j validateLFS --artifact-server-path $(ACT_ARTIFACT_PATH)
act_buildDockerImage:
	act -j buildDockerImage --artifact-server-path $(ACT_ARTIFACT_PATH) --secret-file act_secrets.env
lint: lint_makefile
lint_makefile:
	docker run -v $${PWD}:/tmp/lint -e ENABLE_LINTERS=MAKEFILE_CHECKMAKE oxsecurity/megalinter-ci_light:v6.10.0
