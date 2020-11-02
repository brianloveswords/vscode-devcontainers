# [Choice] Java version: 11, 15
ARG JAVA_VARIANT=15
FROM mcr.microsoft.com/vscode/devcontainers/java:${JAVA_VARIANT}

LABEL org.opencontainers.image.source https://github.com/brianloveswords/vscode-devcontainers

ARG MILL_VERSION="0.8.0"

# [Option] Install Maven
ARG INSTALL_MAVEN="false"
ARG MAVEN_VERSION=""

# [Option] Install Gradle
ARG INSTALL_GRADLE="false"
ARG GRADLE_VERSION=""
RUN if [ "${INSTALL_MAVEN}" = "true" ]; then su vscode -c "source /usr/local/sdkman/bin/sdkman-init.sh && sdk install maven \"${MAVEN_VERSION}\""; fi \
    && if [ "${INSTALL_GRADLE}" = "true" ]; then su vscode -c "source /usr/local/sdkman/bin/sdkman-init.sh && sdk install gradle \"${GRADLE_VERSION}\""; fi

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN curl -Lo cs https://git.io/coursier-cli-linux \
    && chmod +x cs \
    && ./cs setup -y \
    && rm cs

RUN curl -sSL https://github.com/lihaoyi/mill/releases/download/${MILL_VERSION}/${MILL_VERSION} >/usr/local/bin/mill \
    && chmod +x /usr/local/bin/mill \
    && cd /tmp && mill --version

ENV PATH $PATH:/root/.local/share/coursier/bin

RUN cd /tmp && sbt version && rm -rf target project

## Notes for installing graal
# RUN curl -sSLO https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.2.0/graalvm-ce-java11-linux-amd64-20.2.0.tar.gz
# RUN tar -C /usr/local -xvzf graalvm-ce-java11-linux-amd64-20.2.0.tar.gz
# RUN rm graalvm-ce-java11-linux-amd64-20.2.0.tar.gz
# ENV PATH /usr/local/graalvm-ce-java11-20.2.0/bin:${PATH}
# ENV OPENJDK_JAVA_HOME /usr/local/openjdk-15
# ENV GRAALVM_JAVA_HOME /usr/local/graalvm-ce-java11-20.2.0
# RUN gu install native-image
# RUN apt-get -y install --no-install-recommends build-essential libz-dev zlib1g-dev


# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
