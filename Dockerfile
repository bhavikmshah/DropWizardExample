FROM openjdk:8-jdk

RUN mkdir /opt/app 
RUN mkdir /opt/app/DropWizaedExample
COPY newrelic /opt/app/DropWizardExample
COPY target/DropWizardExample-0.0.1-SNAPSHOT.jar /opt/app/DropWizardExample
COPY config.yml /opt/app/DropWizardExample


WORKDIR /opt/app/DropWizardExample
RUN apt-get -qq update
RUN apt-get -qq -y  install curl
RUN curl -s https://download.dataloop.io/pubkey.gpg | apt-key add -
#RUN apt-get -y  install ca-certificates
#RUN apt-get update
RUN apt-get install apt-transport-https ca-certificates -y
RUN echo 'deb https://download.dataloop.io/deb/ stable main' > /etc/apt/sources.list.d/dataloop.list

RUN apt-get update && apt-get install dataloop-agent -y


EXPOSE 9000
EXPOSE 9001
COPY agent.yaml /etc/dataloop/agent.yaml
#RUN update-rc.d dataloop-agent defaults
CMD service dataloop-agent start && java -Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.port=1099 \
  -Dcom.sun.management.jmxremote.local.only=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -javaagent:newrelic.jar \ 
  -jar DropWizardExample-0.0.1-SNAPSHOT.jar \
   server config.yml \ 
