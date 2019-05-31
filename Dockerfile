FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        apt-utils \
        git \
        bc \
        sudo

# Clone the ProxyGen library
RUN git clone https://github.com/facebook/proxygen.git && \
    cd proxygen && \
    git checkout d0a0df6fcf2d6608494cf823ee3a32719f7eff9f

WORKDIR /proxygen/proxygen

# Build and install ProxyGen
RUN ./deps.sh -j $(printf %.0f $(echo "$(nproc) * 1.5" | bc -l))

# Remove gigantic source code tree
RUN rm -rf /proxygen

# Tell the linker where to find ProxyGen and friends
ENV LD_LIBRARY_PATH /usr/local/lib

