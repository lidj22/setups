# Setup

Setup scripts.

## Ubuntu

Development script
```sh
sudo su -c 'wget -O develop.sh https://raw.githubusercontent.com/lidj22/setups/main/ubuntu-22/scripts/develop.sh \
    && chmod +x develop.sh \
    && ./develop.sh \
    && rm develop.sh'
```

Virtualization script
```sh
sudo su -c 'wget -O virtualization.sh https://raw.githubusercontent.com/lidj22/setups/main/ubuntu-22/scripts/virtualization.sh \
    && chmod +x virtualization.sh \
    && ./virtualization.sh \
    && rm virtualization.sh'
```

CUDA scripts:
```sh
# stage 1 script
sudo su -c 'wget -O stage.1.sh https://raw.githubusercontent.com/lidj22/setups/main/ubuntu-22/scripts/aws.cuda/stage.1.sh \
    && chmod +x stage.1.sh \
    && ./stage.1.sh \
    && rm stage.1.sh \
    && reboot'
# reboot

# stage 2 script
sudo su -c 'wget -O stage.2.sh https://raw.githubusercontent.com/lidj22/setups/main/ubuntu-22/scripts/aws.cuda/stage.2.sh \
    && chmod +x stage.2.sh \
    && ./stage.2.sh \
    && rm stage.2.sh'
```

### Vagrant

```
vagrant plugin install vagrant-reload
```