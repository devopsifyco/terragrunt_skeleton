data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "bastion" {
  name               = "${var.prefix}-bastion"
  assume_role_policy = file("./templates/bastion/instance-profile-policy.json")

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "bastion_attach_policy" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_key_pair" "id_rsa_pub" {
  key_name   = var.key_name
  public_key = var.aws_key_pair
}

resource "aws_security_group" "bastion" {
  description = "Control bastion inbound and outbound access"
  name        = "${var.prefix}-bastion"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./templates/bastion/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name             = var.key_name
  subnet_id            = var.subnet_publish[0]

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = merge(
    var.common_tags,
    tomap({ Name = "${var.prefix}-bastion" })
  )
}
