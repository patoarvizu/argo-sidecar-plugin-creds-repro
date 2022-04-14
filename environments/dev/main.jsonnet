(import "jsonnet/grafana.libsonnet") +
(import "jsonnet/prometheus.libsonnet") +
{
  _config:: {
    grafana: {
      port: 3000,
      name: "grafana",
    },
    prometheus: {
      port: 9090,
      name: "prometheus"
    }
  }
}