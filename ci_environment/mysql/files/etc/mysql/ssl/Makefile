
# follows https://help.ubuntu.com/community/GnuTLS roughly sort of

all: server.crt client.crt
			chmod ugo+r client.crt client.key

%.key:
		  certtool --generate-privkey --outfile $@

ca.crt: ca.key ca.tmpl
		  certtool --generate-self-signed --load-privkey $< --template ca.tmpl --outfile $@

%.csr: %.key %.tmpl
			certtool --generate-request --load-privkey $< --template $(basename $@).tmpl --outfile $@

%.crt: %.csr ca.key ca.crt %.tmpl
			certtool --generate-certificate --load-request $< --load-ca-certificate ca.crt --load-ca-privkey ca.key --template $(basename $@).tmpl --outfile  $@

.PHONY: all

.PRECIOUS: %.key


# grant usage on  to  IDENTIFIED BY  REQUIRE ISSUER '/C=XX/O=Travis Test MySQL CA server/CN=Travis MySQL CA'  AND SUBJECT '/O=Travis MySQL Client/CN=Travis MySQL Client';
