resource "aws_key_pair" "self_heal_infra_kp" {
  key_name   = "self-heal-infra-kp"
  public_key = file("~/.ssh/id_rsa.pub")  # Make sure you have this file or change the path

  tags = {
    Name = "self-heal-infra-kp"
    Environment = "dev"
  }
}
