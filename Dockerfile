FROM adoptopenjdk/openjdk8:alpine
MAINTAINER tinytinycn "tinytiny.cn@gmail.com"

ENV AGENT_VERSION=2.0.6 \
    JAVA_START_HEAP=256m \
    JAVA_MAX_HEAP=512m \
    LOG_LEVEL=INFO

WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache shadow curl bash apache-ant \
    && curl -LO https://github.com/awslabs/amazon-kinesis-agent/archive/${AGENT_VERSION}.tar.gz \
    && tar xvzf ${AGENT_VERSION}.tar.gz \
    && rm ${AGENT_VERSION}.tar.gz \
    && mv amazon-kinesis-agent-${AGENT_VERSION} amazon-kinesis-agent \
    && cd amazon-kinesis-agent \
    && ./setup --build

COPY agent.json /etc/aws-kinesis/agent.json
COPY start-aws-kinesis-agent.sh .
CMD ["/bin/bash", "./start-aws-kinesis-agent.sh"]