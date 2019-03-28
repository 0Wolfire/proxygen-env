FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        apt-utils \
        git \
        bc \
        libdouble-conversion1v5 \
        hardening-wrapper \
        sudo

ENV DEB_BUILD_HARDENING=1

# Clone the ProxyGen library
RUN git clone https://github.com/facebook/proxygen.git && \
    cd proxygen && \
    git checkout d3f694c582b0beea41f1e97e8e33b8a8c4968a81

WORKDIR /proxygen/proxygen

# Build and install ProxyGen
RUN ./deps.sh -j $(printf %.0f $(echo "$(nproc) * 1.5" | bc -l))

# Remove gigantic source code tree
RUN rm -rf /proxygen

# Tell the linker where to find ProxyGen and friends
ENV LD_LIBRARY_PATH /usr/local/lib

