FROM stechstudio/gitpod-lambda:latest-dev
LABEL authors="Bubba Hines <bubba@stechstudio.com>"
LABEL vendor="Signature Tech Studio, Inc."
LABEL home="https://github.com/stechstudio/php-lambda-cpp-bootstrap"

RUN yum -y install gdb-gdbserver

### development user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 77777 -G sudo -md /home/develop -s /bin/zsh -p develop develop 

### Gitpod user (2) ###
USER develop

### Environment Variables ###
ENV HOME='/home/develop' \
    PKG_CONFIG="/usr/bin/pkg-config" \
    SOURCEFORGE_MIRROR="netix" \
    PATH="/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    JQ="/usr/bin/jq" \
    CMAKE='/usr/local/bin/cmake' \
    MESON='/usr/local/bin/meson' \
    NINJA='/usr/local/bin/ninja' \
    # terminal colors with xterm
    TERM='xterm-256color' \
    # set the zsh theme 
    ZSH_THEME='agnoster' \
    BUILD_DIR="/home/develop/src"

WORKDIR $HOME

# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for develop: success"

# run the oh-my-zsh installation script  
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/bhilburn/powerlevel9k.git /home/develop/.oh-my-zsh/custom/themes/powerlevel9k
RUN git clone git://github.com/zsh-users/zsh-syntax-highlighting.git /home/develop/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' /home/develop/.zshrc \
    && sed -i '/^ZSH_THEME=.*/i after=POWERLEVEL9K_SHORTEN_DIR_LENGTH=2\nPOWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"\nPOWERLEVEL9K_MODE='nerdfont-complete'\nPOWERLEVEL9K_OS_ICON_FOREGROUND='166'\nPOWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon virtualenv vcs)\nPOWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator)\nPOWERLEVEL9K_PROMPT_ON_NEWLINE=true' /home/develop/.zshrc \
    && sed -i '1s/^/export TERM="xterm-256color"\n/' /home/develop/.zshrc \
    &&  sed -i 's/plugins=(git)/plugins=(command-not-found git git-flow-avh colorize phing pyenv python systemd wd zsh-syntax-highlighting)/g' /home/develop/.zshrc
# custom Bash prompt, because we want to be nice to bash users

RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

RUN mkdir -p ${HOME}/src/build/bin
### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . \! -user develop -group develop -print -quit) \
    && { [ -z "$notOwnedFile" ] \
    || { echo "Error: not all files/dirs in $HOME are owned by 'develop' user & group"; exit 1; } }
# for gdbserver
EXPOSE 2000

VOLUME ${BUILD_DIR}
WORKDIR ${BUILD_DIR}