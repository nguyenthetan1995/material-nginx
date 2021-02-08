# Sử dung node
FROM node:12 as node



# Khai báo tham số
ARG workdir=.
ARG env=prod
ARG version



LABEL version="${version}"
LABEL description="Bike system"



# Khái báo workdir trong node.
WORKDIR /app



# Copy project vào trong workdir của node.
COPY ${workdir}/ /app/



# Cài đặt các thư viện node liên quan.
# RUN npm install



# Chạy lệnh build.
# RUN npm run build --aot



# Sửa dụng nginx
FROM nginx:1.12
# Copy angluar đã được build vào folder chạy của nginx.
COPY --from=node /app/dist/ /var/www/cms/dist/



# Copy file cấu hình chạy cho nginx
COPY --from=node /app/nginx.conf /etc/nginx/nginx.conf



# Cài đặt curl cho câu lệnh check HEALTH
RUN apt-get update && apt-get install -y curl



HEALTHCHECK --interval=1m --timeout=3s \
    CMD curl -f http://localhost || exit 1



# Chạy nginx projeject.
EXPOSE 62001:80
CMD ["nginx", "-g", "daemon off;"]