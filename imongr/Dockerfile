FROM eclipse-temurin:21.0.3_9-jre-jammy

RUN mkdir -p /opt/shinyproxy/ \
  && wget --progress=dot:giga https://www.shinyproxy.io/downloads/shinyproxy-3.1.1.jar -O /opt/shinyproxy/shinyproxy.jar
COPY application.yml /opt/shinyproxy/application.yml
ADD https://raw.githubusercontent.com/mong/imongr/main/pkgdown/favicon/favicon.ico /opt/shinyproxy/

WORKDIR /opt/shinyproxy/
CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
