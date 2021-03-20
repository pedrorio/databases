EXECS = distributed_permissions permissions install

.PHONY: $(EXECS)

all: $(EXECS)

distributed_permissions:
	find ./* -type d -exec fs sa {} system:administrators rlidwka \;
	find ./* -type d -exec fs sa {} ciist.web rl \;
	find ./* -type d -exec fs sa {} ist197241 rlidwka \;
	find ./* -type d -exec fs sa {} ist197241.daemon rlidwk \;

permissions:
	chmod -R 755 .

install:
	pip3 install -r requirements.txt