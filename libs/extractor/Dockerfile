FROM ubuntu:18.04

RUN echo 

RUN apt-get update && apt-get install -y \
  netcat net-tools git sudo wget

# ADD CRYSTAL USER
RUN mkdir -p /home/crystal/src/code && \
  mkdir -p /home/crystal/src/crystal
RUN chmod -R 777 /home
RUN groupadd crystal
RUN useradd -r -u 1000 -g crystal crystal
RUN usermod -a -G sudo crystal
RUN echo ' crystal ALL=(ALL)   NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/crystal/src

# PROXY FOR SPEED UP DOCKER BUILDS
RUN echo "using https://github.com/sameersbn/docker-apt-cacher-ng"
RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
# Add this to /etc/apt/apt.conf.d/01proxy  on host:
# Acquire::HTTP::Proxy "http://172.17.0.1:3142";
# Acquire::HTTPS::Proxy "false";

ENV LLVM_CONFIG /usr/bin/llvm-config-5.0

# CRYSTAL DEPS
RUN apt-get install -y \
  gnupg2 \
  zsh \
  llvm-5.0 \
  llvm-5.0-dev \
  libbsd-dev \
  libedit-dev \
  libevent-core-* \
  libevent-dev \
  libevent-extra-* \
  libevent-openssl-* \
  libevent-pthreads-* \
  libgmp-dev \
  libgmpxx4ldbl \
  libssl-dev \
  libxml2-dev \
  libyaml-dev \
  libgc-dev \
  libreadline-dev \
  automake \
  libtool \
  libpcre3-dev \
  wget \
  build-essential \
  curl \
  nano \
  vim \
  tree \
  gdb

# CRYSTAL
RUN wget https://keybase.io/crystal/pgp_keys.asc
RUN cat pgp_keys.asc
RUN apt-key add pgp_keys.asc
RUN rm pgp_keys.asc
RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
RUN apt-get install -y \
  crystal 

RUN git clone https://github.com/crystal-lang/crystal.git /home/crystal/src/crystal --depth=10 && \
    cd /home/crystal/src/crystal && make
    
RUN git clone https://github.com/crystal-lang/shards.git /home/crystal/src/shards --depth=10 && \
    cd /home/crystal/src/shards && make


USER crystal

# ZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh && sudo /bin/bash install.sh && rm install.sh
# RUN sudo usermod -s /usr/bin/zsh $(whoami)
RUN sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="evan"/g' ~/.zshrc

# CRYSTAL 0.27.2 NEEDS THIS ON MY COMPUTER TO BUILD - error with LLVM-6.0
RUN echo "\nexport LLVM_CONFIG=/usr/bin/llvm-config-5.0" >> ~/.zshrc

# CHANGE DEFAULT CRYSTAL to /home/crystal/src/crystal/bin
RUN echo "\nexport CRYSTAL_PATH=/home/crystal/src/crystal/src" >> ~/.zshrc
RUN echo "\nexport PATH=\$PATH:/home/crystal/src/crystal/bin:/home/crystal/src/shards/bin" >> ~/.zshrc
RUN sudo apt-get remove crystal -y

RUN sudo chown -R crystal:crystal /home && chmod -R 774 /home 
CMD ["/usr/bin/zsh"]
VOLUME ["/home/crystal/src"]
