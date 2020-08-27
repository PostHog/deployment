
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

resource "aws_ebs_volume" "ch_ebs_volume_2" {
  availability_zone = "${var.availability_zone}"
  size = 120
  #snapshot_id = 
  encrypted = false
  type = "gp2"
  tags {
    Name = "ch_ebs_volume_1"
  }
}

resource "aws_volume_attachment" "ch_ebs_volume_att_2" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ch_ebs_volume_2.id}"
  instance_id = "${aws_instance.ch_node_2.id}"
}

output "ip_ch_node_2" {
  value = "${aws_instance.ch_node_2.public_ip}"
}

output "id_ch_ebs_volume_2" {
  value = "${aws_ebs_volume.ch_ebs_volume_2.id}"
}

output "arn_ch_ebs_volume_2" {
  value = "${aws_ebs_volume.ch_ebs_volume_2.arn}"
}
