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
    target_vault_name = "${aws_backup_vault.np-vault.name}"
    schedule          = "cron(0 1 ? * 2 *)"
    lifecycle = {
      cold_storage_after = 1
      delete_after       = 91
    }
  }
}

data "aws_iam_role" "backup-role" {
  name = "AWSBackupDefaultServiceRole"
}

resource "aws_backup_selection" "np-resources" {
  iam_role_arn = "${data.aws_iam_role.backup-role.arn}"
  name         = "NPWeatherApp"
  plan_id      = "${aws_backup_plan.np-backup.id}"

  resources = [
    "${data.aws_ebs_volume.bastion-volume.arn}",
    "${data.aws_ebs_volume.server1-volume.arn}",
    "${data.aws_ebs_volume.server2-volume.arn}",
    "${aws_dynamodb_table.dynamodb-tf-state-lock.arn}",
  ]
}
