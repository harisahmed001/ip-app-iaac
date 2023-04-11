resource "helm_release" "helm_chart" {
  name  = var.chart_name
  chart = var.chart
  wait  = var.wait
}
