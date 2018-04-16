provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "admin"
  password    = "${var.password}"
  auth_url    = "${var.auth_url}"
  region      = "RegionOne"
  domain_name = "Default"  
}

resource "openstack_compute_instance_v2" "web_server" {
  name      = "web_server"
  availability_zone= "nova"
  region    = "RegionOne"
  image_id  = "cd4c2804-eba3-4063-98c2-69de61458007"
  flavor_id = "cbcd1bb3-73a3-40e8-90b3-b794b6bec150"
  key_pair  = "Terraform"
  security_groups=["default"]
  network = {
	 name = "Private"
  } 

 provisioner "chef" {
    connection {
      type     = "ssh"
      user     = "${var.user_instanc}"
      password = "${var.passw_instanc}"
    }
    environment     = "_default"
    run_list        = ["role[web_server]"]
    node_name       = "web_server"
   # validation_client_name ="devops-validator"
   # validation_key  ="${file("/home/terraform/devops-validator.pem")}"

    server_url      = "https://192.168.103.240/organizations/devops"
    recreate_client = "true"
    user_name       = "admin"    
    user_key        = "${file("/home/terraform/admin.pem")}"
    log_to_file     = "true"
    fetch_chef_certificates = "true"
    ssl_verify_mode = ":verify_none"

	 }
}
