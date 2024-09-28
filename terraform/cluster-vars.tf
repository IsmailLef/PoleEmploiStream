variable "project_id" {
  description = "The ID of the Google Cloud Platform project."
  type        = string
  default     = "sdtd-402113"
}

variable "credentials_file" {
  description = "The path to the service account key file for authentication."
  type        = string
  default     = "sdtd-402113-de780093b26b.json"
}

variable "region" {
  description = "The default GCP region to use."
  type        = string
  default     = "us-central1"
}

variable "network" {
  default = "default"
}

variable "pod_cidr" {
  default = "10.243.0.0/16"
}
