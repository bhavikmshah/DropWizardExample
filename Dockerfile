FROM openjdk-7-jdk

COPY /newrelic /opt/app/DropWizardExample
COPY /target/DropWizardExample-0.0.1-SNAPSHOT.jar /opt/app/DropWizardExample
COPY config.yml /opt/app/DropWizardExample

WORKDIR /opt/app/DropWizardExample


EXPOSE 9000
EXPOSE 9001

CMD java -javaagent:./newrelic/newrelic.jar -jar DropWizardExample-0.0.1-SNAPSHOT.jar server config.yml
