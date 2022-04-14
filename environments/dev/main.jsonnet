(import "grafana.libsonnet") +
(import "prometheus.libsonnet") +
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