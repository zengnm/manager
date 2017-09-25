upstream tomcat_xxx {
    server 127.0.0.1:8001  weight=10 max_fails=2 fail_timeout=30s;
}
server
{
    listen                   80;
    server_name              xxx.com;
    access_log               log_home/xxx.com_access.log main;
    error_log                log_home/xxx.com_error.log warn;
    # chunkin on;
    # error_page 411 = @my_error;
    # location @my_error {
    #     chunkin_resume;
    # }
    root work/xxx.com/;
    location / {
        proxy_next_upstream     http_500 http_502 http_503 http_504 error timeout invalid_header;
        proxy_set_header        Host  $host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass              http://tomcat_xxx;
        expires                 0;
    }
    location /logs/ {
        autoindex       off;
        deny all;
    }
}
