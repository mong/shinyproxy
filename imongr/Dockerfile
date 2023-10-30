FROM openjdk:22-ea-20

RUN mkdir -p /opt/shinyproxy/
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-2.6.1.jar -O /opt/shinyproxy/shinyproxy.jar
COPY application.yml /opt/shinyproxy/application.yml
ADD https://raw.githubusercontent.com/mong/imongr/main/pkgdown/favicon/favicon.ico /opt/shinyproxy/

WORKDIR /opt/shinyproxy/
CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
