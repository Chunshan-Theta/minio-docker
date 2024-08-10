# 使用一个轻量级的基础镜像
FROM alpine:3.18

# 安装 mc、jq 和 cron
RUN apk add --no-cache bash curl jq nano \
    && curl -O https://dl.min.io/client/mc/release/linux-amd64/mc \
    && chmod +x mc \
    && mv mc /usr/local/bin/ \
    && apk add --no-cache ca-certificates

# 将脚本复制到容器中
COPY check_and_set_quota.sh /usr/local/bin/

# 复制crontab 配置文件到/etc
COPY crontab /etc/crontabs/root


# 使脚本可执行
RUN chmod +x /usr/local/bin/check_and_set_quota.sh

# 运行cron并持续运行
CMD ["crond", "-f"]
