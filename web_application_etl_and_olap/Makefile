EXECS = report schema integrity views populate queries star_schema etl olap

.PHONY: $(EXECS)

all: $(EXECS)

schema:
	psql -U postgres -f schema.sql

integrity:
	psql -U postgres -f ri/ic1.sql
	psql -U postgres -f ri/ic2.sql
	psql -U postgres -f ri/ic3.sql

views:
	psql -U postgres -f view/view.sql

populate:
	psql -U postgres -f populate.sql

queries:
	psql -U postgres -f sql/q1.sql -o sql/a1.txt
	psql -U postgres -f sql/q2.sql -o sql/a2.txt
	psql -U postgres -f sql/q3.sql -o sql/a3.txt
	psql -U postgres -f sql/q4.sql -o sql/a4.txt

star_schema:
	psql -U postgres -f ss/star_schema.sql

etl:
	psql -U postgres -f etl.sql

olap:
	psql -U postgres -f olap.sql -o olap.txt

report:
	mkdir -p out
	pdflatex -output-directory=out -shell-escape report.tex
