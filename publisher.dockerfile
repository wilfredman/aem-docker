FROM aem-base
MAINTAINER Adfinis SyGroup/Namics

# AEM VERSION, e.g., 6.3
ARG version

# Copies required build media
COPY AEM_${version}_Quickstart.jar /aem/AEM_${version}_Quickstart.jar
COPY license.properties /aem/license.properties

# Extracts AEM
WORKDIR /aem
RUN java -XX:MaxPermSize=256m -Xmx1024M -jar AEM_${version}_Quickstart.jar -unpack -r publish -p 4503

# Add customised log file, to print the logging to standard out.
COPY aem-publisher/org.apache.sling.commons.log.LogManager.config /aem/crx-quickstart/install

# Installs AEM
WORKDIR /
RUN chmod +x /aem/aemInstaller.py
RUN python /aem/aemInstaller.py -i /aem/AEM_${version}_Quickstart.jar -r publish -p 4503

WORKDIR /aem/crx-quickstart/bin
#Replaces the port within the quickstart file with the standard publisher port
RUN sed -i "s|4502|4503|g" quickstart


EXPOSE 4503 8000
ENTRYPOINT ["/aem/crx-quickstart/bin/quickstart"]
