# Start from the code-server Debian base image
FROM codercom/code-server:4.111.0-39

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# -----------
# Custom Software for Python and Rust
# -----------

# 1. Install System Dependencies (Python3, pip, and Rust build tools)
#RUN sudo apt-get update && sudo apt-get install -y \
#  python3 \
#  python3-pip \
#  build-essential \
#  curl \
#  gcc \
#  make \
#  && sudo rm -rf /var/lib/apt/lists/*

# 2. Install Rust (using rustup)
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#ENV PATH="/home/coder/.cargo/bin:${PATH}"

# 3. Install VS Code Extensions
RUN code-server --install-extension ms-python.python \
  && code-server --install-extension rust-lang.rust-analyzer

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
