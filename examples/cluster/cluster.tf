module "home_cluster" {
  source = "../../terraform"
  tailscale = {
    use_vault = true
  }
  HCP_CLIENT_ID = var.HCP_CLIENT_ID
  HCP_CLIENT_SECRET = var.HCP_CLIENT_SECRET
}