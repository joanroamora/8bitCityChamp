output "vm_name" {
  description = "The name of the deployed Compute Engine VM"
  value       = google_compute_instance.eightbitcitychamp_vm.name
}

output "vm_public_ip" {
  description = "The public external IP address of the 8bitCityChamp web server"
  value       = google_compute_address.eightbitcitychamp_ip.address
}

output "web_url" {
  description = "Direct HTTP URL to access the Urban Champion retro web page"
  value       = "http://${google_compute_address.eightbitcitychamp_ip.address}"
}

output "vpc_name" {
  description = "Name of the dedicated VPC network"
  value       = google_compute_network.eightbitcitychamp_vpc.name
}

output "subnet_name" {
  description = "Name of the dedicated Subnetwork"
  value       = google_compute_subnetwork.eightbitcitychamp_subnet.name
}
