# Start from the code-server Debian base image
FROM codercom/code-server:4.111.0-39

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Install VS Code Extensions
RUN code-server --install-extension ms-python.python \
  && code-server --install-extension rust-lang.rust-analyzer

# -----------

# Port
ENV PORT=8080

# Use our entrypoint script
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
