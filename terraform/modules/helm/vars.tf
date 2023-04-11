variable "chart_name" {
  default     = "undefined"
  description = "Name of the resource"
}

variable "chart" {
  default     = "chart"
  description = "Name of the chart"
}

variable "wait" {
  default     = ""
  description = "Wait condition for helm resource"
}
