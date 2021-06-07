# compile
FROM arm64v8/maven:3.8.1-jdk-8-openj9 AS builder
COPY backend/ /app/
WORKDIR /app
RUN  mvn clean install && mvn clean package -f ruoyi-admin/pom.xml

# package
FROM openjdk:8-jre-alpine3.9
COPY --from=builder /app/ruoyi-admin/target/ruoyi-admin.jar /app/
RUN apk add --update --no-cache ttf-dejavu fontconfig

EXPOSE 8080

CMD ["java", "-jar", "-Duser.timezone=Asia/Shanghai", "-Xms256m", "-Xmx1024m", "-XX:MetaspaceSize=128m", "-XX:MaxMetaspaceSize=512m", "/app/ruoyi-admin.jar"]
