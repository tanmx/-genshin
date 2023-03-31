FROM debian:unstable-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy build artefacts to run
WORKDIR /opt/

# Setup rootless user which works with the volume mount
RUN curl https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk -o /tmp/applemusic.zip \
 && unzip -q /tmp/applemusic.zip -d /tmp && mv /tmp/lib /opt/ && rm -rf /tmp/* \
 && curl -L https://github.com/SideStore/omnisette-server/releases/download/0.2.0/omnisette-server-linux-x86_64 -o /opt/omnisette-server \
 && chmod -R +wx /opt/ \
 && chmod +x /opt/omnisette-server

# Run the artefact
EXPOSE 80
ENTRYPOINT [ "/opt/omnisette-server"]
