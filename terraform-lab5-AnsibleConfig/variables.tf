variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key"
  default     = "./id_rsa.pub"
}