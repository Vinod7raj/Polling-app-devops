FROM maven:3.9.6-eclipse-temurin-11 as builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:11-jre-alpine
WORKDIR /app 
RUN addgroup -S devops && adduser -S vinod -G devops
COPY --chown=vinod:devops --from=builder /build/target/*.jar webapp.jar
USER vinod
EXPOSE 8080
ENTRYPOINT ["java","-jar","webapp.jar"]
