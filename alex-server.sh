ssh alex@192.168.1.2 bash -c 'echo; sudo rm -rf /tmp/olivetin && mkdir -p /tmp/olivetin'

rsync -a --delete dist/OliveTin alex@192.168.1.2:/tmp/olivetin/OliveTin

rsync -a --delete webui/ alex@192.168.1.2:/tmp/olivetin/webui/

rsync -a /home/alex/gitworkspace/personal/alex-server/apps/olive-tin/config.yaml alex@192.168.1.2:/tmp/olivetin/config.yaml

ssh alex@192.168.1.2 bash -c "echo; sudo rsync -a --delete /tmp/olivetin/OliveTin /usr/local/bin/OliveTin"

ssh alex@192.168.1.2 bash -c 'echo; sudo rsync -a --delete /tmp/olivetin/webui/ /var/www/olivetin/'

ssh alex@192.168.1.2 bash -c 'echo; sudo rsync -a --delete /tmp/olivetin/config.yaml /etc/OliveTin/config.yaml'

ssh alex@192.168.1.2 bash -c 'echo; sudo rm -rf /tmp/olivetin'

ssh alex@192.168.1.2 bash -c 'echo; sudo rc-service olive-tin restart'
