TARGET = master vpc resource eb
BUCKET_NAME=$(shell cat param.json \
	| jq -r --arg keyName "S3Bucket" '.[] \
	| select(.ParameterKey == "S3Bucket") \
	| .ParameterValue')

KEY_NAME=$(shell cat param.json \
	| jq -r --arg keyName "S3Key" '.[] \
	| select(.ParameterKey == "S3Key") \
	| .ParameterValue')

.PHONY: validate $(TARGET)

validate: $(TARGET)

$(TARGET): %: %.json
	aws cloudformation validate-template --template-body file://$<

upload-initial-goapp:
	zip -r - goapp | aws s3 cp - s3://$(BUCKET_NAME)/$(KEY_NAME)
