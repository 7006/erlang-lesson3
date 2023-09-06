.PHONY: syntax-check-json-documents
syntax-check-json-documents:
	set -e; \
	for FILE in $$(ls json_documents/*.json | sort); \
	do \
		echo syntax check json document $$FILE; \
		echo ; \
		jq . $$FILE; \
	done

.PHONY: clean
clean:
	rm -rf *.beam

.PHONY: compile
compile:
	erlc -pa . *.erl
