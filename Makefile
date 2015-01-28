TARGET=master.json resource.json eb.json

.PHONY: validate

validate:
	aws cloudformation validate-template --template-body file://master.json
	aws cloudformation validate-template --template-body file://resource.json
	aws cloudformation validate-template --template-body file://eb.json
