EXECS = report schema populate queries

.PHONY: $(EXECS)

all: $(EXECS)

report:
	$(MAKE) report --directory=report

schema:
	psql -U postgres -f schema.sql

populate:
	psql -U postgres -f populate.sql

queries:
	psql -U postgres -f queries.sql -o output.txt