variable "aws_access_key" {}
 
variable "aws_secret_key" {}
 
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}
 
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow all inbound traffic on port 22"
 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_instance" "worker" {
  ami = "ami-d43396bc"
  instance_type = "c3.4xlarge"
  key_name = "henrikhodne-melody-passless"
  security_groups = ["allow_ssh"]
  depends_on = ["aws_security_group.allow_ssh"]
 
  count = 2
 
  connection {
    user = "ubuntu"
    key_file = "/Users/henrikhodne/.ssh/id_rsa_aws"
  }
 
  provisioner "remote-exec" {
    script = "setup_worker.sh"
  }
 
  provisioner "remote-exec" {
    inline = [
      "sudo -u travis bash -c 'export HOME=/home/travis; source /home/travis/local/share/chruby/chruby.sh; cd /home/travis/travis-worker; chruby jruby; nohup $(pwd)/bin/thor travis:worker:boot >> log/worker.log 2>&1 &'"
    ]
  }
}