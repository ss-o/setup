
# Python
##########################################################
installPython() {
    title "Installing Python3 with PIP"
    sudo apt install -y build-essential libssl-dev libffi-dev python-dev python3-pip
    sudo ln -s /usr/bin/pip3 /usr/bin/pip
    export PATH=/usr/local/bin/python:$PATH

    installedPython=1
    breakLine
}