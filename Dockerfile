FROM debian:unstable-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy build artefacts to run
WORKDIR /opt/

# Setup rootless user which works with the volume mount
RUN echo "xxxxxxx" && arch
RUN useradd -ms /bin/bash omnisette \
 && chown -R omnisette /opt/ \
 && chmod -R +wx /opt/ \
 && curl https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk -o /tmp/applemusic.zip \
 && unzip -q /tmp/applemusic.zip -d /tmp && mv /tmp/lib /opt/ && rm -rf /tmp/* \
 && tag_name=`curl -s https://api.github.com/repos/SideStore/omnisette-server/releases/latest | grep tag_name|cut -f4 -d "\""` \
 && curl -L https://github.com/SideStore/omnisette-server/releases/download/${tag_name}/omnisette-server-linux-x86_64 -o /opt/omnisette-server \
 && chmod +x /opt/omnisette-server

# Run the artefact
USER omnisette
EXPOSE 80
ENTRYPOINT [ "/opt/omnisette-server" ]
