.PHONY: check-json-examples-files
check-json-examples-files:
	set -e; \
	for FILE in $$(ls json_examples/*.json | sort); \
	do \
		echo check json document from file \"$$FILE\"; \
		echo ; \
		jq . $$FILE; \
	done

.PHONY: clean
clean:
	rm -rf .beam

.PHONY: compile
compile:
	erlc *.erl