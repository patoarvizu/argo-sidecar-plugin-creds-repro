(import "kubernetes.libsonnet") +
{
  // Grafana
  grafana: {
    deployment: $.k.deployment.new($._config.grafana.name, [{
      image: 'grafana/grafana',
      name: $._config.grafana.name,
      ports: [{
          containerPort: $._config.grafana.port,
          name: 'ui',
      }],
    }]),
    service: $.k.service.new($._config.grafana.name, $._config.grafana.port),
  },
}