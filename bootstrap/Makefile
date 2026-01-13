.PHONY: deps apply

deps:
	ansible-galaxy role install -r requirements.yaml -p roles/galaxy

apply:
	ansible-playbook site.yaml
