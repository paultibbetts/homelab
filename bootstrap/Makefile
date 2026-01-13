.PHONY: setup deps deps-upgrade site

GALAXY_FLAGS ?=
PLAYBOOK_FLAGS ?=

setup:
	@command -v uv >/dev/null || \
		(echo "uv is not installed" && exit 1)
	uv sync

deps: setup
	uv run ansible-galaxy role install -r requirements.yaml -p roles/galaxy $(GALAXY_FLAGS)
	uv run ansible-galaxy collection install -r requirements.yaml $(GALAXY_FLAGS)

deps-upgrade: setup
	uv run ansible-galaxy role install -r requirements.yaml -p roles/galaxy --force $(GALAXY_FLAGS)
	uv run ansible-galaxy collection install -r requirements.yaml --force $(GALAXY_FLAGS)

site: deps
	uv run ansible-playbook site.yaml $(PLAYBOOK_FLAGS)
