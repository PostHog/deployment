
# Possible volume types
# volume_type = 
#   gp2 for General Purpose SSD, 
#   io1 for Provisioned IOPS SSD, 
#   st1 for Throughput Optimized HDD, 
#   sc1 for Cold HDD, or 
#   standard for Magnetic

resource "aws_instance" "ch_node_2" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.ch_node_security_group.id}",
  ]
  key_name = "${var.key_name}"

  root_block_device {
    volume_size = "${var.root_block_device_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ch_node_2"
  }
}
