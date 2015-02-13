TARGET = master vpc resource eb

.PHONY: validate $(TARGET)

validate: $(TARGET)

$(TARGET): %: %.json
	aws cloudformation validate-template --template-body file://$<

upload-initial-goapp:
	zip -r - goapp | aws s3 cp - s3://smagch-docker/initial-docker.zip
