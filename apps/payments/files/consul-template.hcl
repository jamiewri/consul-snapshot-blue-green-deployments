consul {
  address = "consul-consul-server:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}
template {
  source      = "/app/nginx.conf.template"
  destination = "/etc/nginx/nginx.conf"
  perms       = 0644
  command     = "/usr/sbin/nginx -s reload"
}

