#!/bin/bash

set -e

if [ -z "$ENV" ]
then
    ENV=staging
fi

git rev-parse --verify --quiet origin/${ENV} || (git checkout -b ${ENV} && git fetch)
git checkout origin/${ENV}

tar cjf nginx.conf.tag.gz . --exclude=./nginx.conf.tag.gz --exclude=./nginx_dns_reload.sh

backend=$(aws ec2 describe-instances --filters "Name=tag:Application:name,Values=nginx,Name=tag:Application:env,Values=$ENV" --query "Reservations[*].Instances[*].PrivateDnsName" --output text --region us-east-1)
for i in ${backend}
do
    echo $i
done

function cecho() {
    case $1 in
    red)
        color=31
        ;;
    green)
        color=32
        ;;
    *)
        echo $2
        return 1
        ;;
    esac
    echo -e "\033[49;${color};1m$2\033[0m"
    return 0
}

function reload_nginx() {
    for i in $backend
    do
        while true;
        do
            if [ `ssh -oStrictHostKeyChecking=no -t ec2-user@$i "
                ps -ef | grep 'nginx: worker process is shutting down' | grep -v grep
                2>/dev/null" 2>/dev/null | wc -l` -eq 0 ]; then
                break
            fi

            sleep 5
        done

        if ! scp -oStrictHostKeyChecking=no nginx.conf.tag.gz ec2-user@${i}:/home/ec2-user/ngx_openresty/nginx/conf
        then
            cecho red "[$i] git pull failed,please check !"
            exit 1
        else
            cecho green "[$i] git pull success."
        fi

        if ! ssh -oStrictHostKeyChecking=no -t ec2-user@$i "
            cd /home/ec2-user/ngx_openresty/nginx/conf && find /home/ec2-user/ngx_openresty/nginx/conf/ -not -path /home/ec2-user/ngx_openresty/nginx/conf/ -not -path /home/ec2-user/ngx_openresty/nginx/conf/nginx.conf.tag.gz | xargs rm -fr && tar xf nginx.conf.tag.gz && \
            cd /home/ec2-user/ngx_openresty/nginx/sbin/ && sudo ./nginx -t
        "
        then
            cecho red "[$i] ngx cfg check failed,please check !"
            exit 1
        else
            cecho green "[$i] ngx cfg check success."
        fi

        if ! ssh -oStrictHostKeyChecking=no -t ec2-user@$i "cd /home/ec2-user/ngx_openresty/nginx/sbin && sudo ./nginx -s reload "
        then
            cecho red "[$i] nginx reload failed,please check !"
            exit 1
        else
            cecho green "[$i] nginx reload success."
        fi
    done

    return 0
}

reload_nginx
