# Docker
##########################################################
installDocker() {
    title "Installing Docker CE with Docker Compose"
    sudo apt install -y docker-ce
    curlToFile "https://github.com/docker/compose/releases/download/${versionDockerCompose}/docker-compose-$(uname -s)-$(uname -m)" "/usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose

    sudo groupadd docker
    sudo usermod -aG docker "${USER}"

    notify "Install a separate runc environment? (recommended on chromebooks)"

    while true; do
        read -p -r "(y/n)" yn
        case ${yn} in
        [Yy]*)
            if [[ ${installedGo} -ne 1 ]] && [[ "$(command -v go)" == '' ]]; then
                breakLine
                installGoLang
            fi

            sudo sed -i -e 's/ExecStartPre=\/sbin\/modprobe overlay/#ExecStartPre=\/sbin\/modprobe overlay/g' /lib/systemd/system/containerd.service

            sudo apt install libseccomp-dev -y
            go get -v github.com/opencontainers/runc

            cd "${GOPATH}/src/github.com/opencontainers/runc" || exit
            make BUILDTAGS='seccomp apparmor'

            sudo cp "${GOPATH}/src/github.com/opencontainers/runc/runc" /usr/local/bin/runc-master

            curlToFile "${repoUrl}docker/daemon.json" /etc/docker/daemon.json
            sudo systemctl daemon-reload
            sudo systemctl restart containerd.service
            sudo systemctl restart docker
            break
            ;;
        [Nn]*) break ;;
        *) echo "Please answer yes or no." ;;
        esac
    done

    breakLine
}