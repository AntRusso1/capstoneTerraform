resource "aws_key_pair" "bastion" {
	key_name = var.bastion_key_name
	public_key = file(var.bastion_public_key)
}

resource "aws_key_pair" "db" {
    key_name = var.db_key_name
		public_key = file(var.db_public_key)
}

resource "aws_key_pair" "web" {
    key_name = var.web_key_name
		public_key = file(var.web_public_key)
}
