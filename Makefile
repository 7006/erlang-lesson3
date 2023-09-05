.PHONY: check-json-documents
check-json-documents:
	set -e; \
	for FILE in $$(ls json_documents/*.json | sort); \
	do \
		echo check json document $$FILE; \
		echo ; \
		jq . $$FILE; \
	done

.PHONY: clean
clean:
	rm -rf *.beam

.PHONY: compile
compile:
	erlc -pa . *.erl
