.PHONY: $(zip)

zip=package.zip
name=HelloPython
upload_dir=./upload

install:
	./bin/pip install -r ./requirements.txt -t $(upload_dir)

$(upload_dir)/main.py: main.py
	cp -f $< $@

$(zip): install $(upload_dir)/main.py
	zip -r $@ $(upload_dir)

update_function: $(zip)
	aws lambda update-function-code \
		--function-name $(name) \
		--zip-file fileb://$(zip)

create_function: $(zip)
	aws lambda create-function\
		--region ap-northeast-1 \
		--function-name $(name) \
		--zip-file fileb://$(zip) \
		--role arn:aws:iam::941644024476:role/lambda_basic_execution \
		--handler main.hello \
		--runtime python2.7 \
		--timeout 15 \
		--memory-size 512

bin:
	virtualenv -p python2 . 

clean_code:
	rm -f $(zip)

clean_virtualenv: 
	rm -rf ./bin
	rm -rf ./lib
	rm -rf ./include

