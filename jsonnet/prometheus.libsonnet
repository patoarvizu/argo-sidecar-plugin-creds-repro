(import "kubernetes.libsonnet") +
{
  // Prometheus
  prometheus: {
    deployment: $.k.deployment.new($._config.prometheus.name, [{
      image: 'prom/prometheus',
      name: $._config.prometheus.name,
      ports: [{
          containerPort: $._config.prometheus.port,
          name: 'api',
      }],
    }]),
    service: $.k.service.new($._config.prometheus.name, $._config.prometheus.port),
  },
}