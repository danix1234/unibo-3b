# uso ubuntu:focal per analogia con l'immagine usata in mongodb
FROM ubuntu:focal
# FROM ubuntu:xenial

RUN	apt-get -y update	 &&	\
	apt-get -y install --no-install-recommends \
	  nodejs	\
	  npm			\
	  curl			\
	  wget			\
		&& \
	apt-get -y clean; \
  rm -rf /var/lib/apt/lists/*;

# NB: occorre copiare ./app/package.json in /root/app 
# prima di eseguire npm install altrimenti provoca warning

ENV WORKINGDIR=/root/app
WORKDIR ${WORKINGDIR}
RUN	mkdir -p ${WORKINGDIR} && chmod 666 ${WORKINGDIR}
COPY 	./app  ${WORKINGDIR}/

RUN	npm install

EXPOSE 3000

ENTRYPOINT [ "nodejs", "index.js" ]
# CMD nodejs index.js

