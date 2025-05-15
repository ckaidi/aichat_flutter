FROM docker.1ms.run/nginx

# 复制前端构建文件和SSL证书
COPY ./dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]