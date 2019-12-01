resource "aws_backup_vault" "np-vault" {
  name        = "NPVault"
}

data "aws_ebs_volume" "bastion-volume" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.bastion.id}"]
  }
}

data "aws_ebs_volume" "server1-volume" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.server-1.id}"]
  }
}

data "aws_ebs_volume" "server2-volume" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.server-2.id}"]
  }
}

resource "aws_backup_plan" "np-backup" {
  name = "NPBackupPlan"

  rule {
    rule_name         = "Weekly"
    target_vault_name = "${aws_backup_vault.NPVault.name}"
    schedule          = "cron(0 1 ? * 1 *)"
  }
}

data "aws_iam_role" "backup-role" {
  name = "AWSBackupDefaultServiceRole"
}

resource "aws_backup_selection" "example" {
  iam_role_arn = "${aws_iam_role.backup-role.arn}"
  name         = "NPWeatherApp"
  plan_id      = "${aws_backup_plan.np-backup.id}"

  resources = [
    "${aws_ebs_volume.bastion-volume.arn}",
    "${aws_ebs_volume.server1-volume.arn}",
    "${aws_ebs_volume.server2-volume.arn}",
    "${aws_dynamodb_table.dynamodb-tf-state-lock.arn}",
  ]
}
