server {
    listen 80;
    listen [::]:80;
    server_name api.huynhhanh.com;
    return 301 https://api.huynhhanh.com$request_uri;
}
server {
    server_name api.huynhhanh.com;

    location / {
#proxy_pass http://localhost:6789;
        proxy_pass https://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/huynhhanh.com-0001/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/huynhhanh.com-0001/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

