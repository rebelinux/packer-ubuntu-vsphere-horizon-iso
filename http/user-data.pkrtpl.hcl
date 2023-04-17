#cloud-config
autoinstall:
    version: 1
    early-commands:
        # Stop ssh for packer
        - sudo systemctl stop ssh
    locale: ${vm_guest_os_language}
    keyboard:
        layout: ${vm_guest_os_keyboard}
    identity:
        hostname: ${vm_hostname}
        username: ${build_username}
        password: ${build_password_encrypted}
    ssh:
        install-server: yes
        allow-pw: yes
    storage:
        layout:
            name: direct
    package_update: true
    package_upgrade: true
    apt:
        primary:
            - arches: [i386, amd64]
              uri: "http://de.archive.ubuntu.com/ubuntu/"
    packages:
        - apt-transport-https
        - ca-certificates
        - curl
        - gnupg-agent
        - software-properties-common
        - ufw
        - unzip
        - python3
        - python3-pip
        - sshpass
        - open-vm-tools
        - krb5-user
        - sssd-ad 
        - sssd-tools 
        - realmd
        - adcli
    user-data:
        disable_root: false
        timezone: ${vm_guest_os_timezone}
    late-commands:
        - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
        - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
        - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}

