########################################
# Snowflake authentication (Terraform)
########################################

variable "snowflake_organization_name" {
  description = "Snowflake organization name (e.g. QXNBBYZ)."
  type        = string
}

variable "snowflake_account_name" {
  description = "Snowflake account name (e.g. US25909)."
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake admin user used by Terraform."
  type        = string
}

variable "snowflake_password" {
  description = "Password for the Snowflake admin user."
  type        = string
  sensitive   = true
}

variable "snowflake_admin_role" {
  description = "Snowflake role used by Terraform for provisioning."
  type        = string
  default     = "ACCOUNTADMIN"
}

########################################
# dbt Cloud
########################################

variable "dbt_cloud_account_id" {
  description = "dbt Cloud account ID."
  type        = number
}

variable "dbt_cloud_token" {
  description = "dbt Cloud API token."
  type        = string
  sensitive   = true
}

variable "dbt_cloud_host_url" {
  description = "dbt Cloud API host URL."
  type        = string
}

variable "dbt_project_name" {
  description = "dbt Cloud project name."
  type        = string
  default     = "leap-case"
}

########################################
# Snowflake DEV user
########################################

variable "dev_user_name" {
  description = "Snowflake username for the DEV environment."
  type        = string
}

variable "dev_user_password" {
  description = "Password for the DEV Snowflake user."
  type        = string
  sensitive   = true
}
