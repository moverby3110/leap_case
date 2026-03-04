########################################
# Providers
########################################

provider "snowflake" {
  organization_name = var.snowflake_organization_name
  account_name      = var.snowflake_account_name
  user              = var.snowflake_user
  password          = var.snowflake_password
  role              = var.snowflake_admin_role
}

provider "dbtcloud" {
  account_id = var.dbt_cloud_account_id
  token      = var.dbt_cloud_token
  host_url   = var.dbt_cloud_host_url
}

########################################
# Snowflake DEV setup
########################################

resource "snowflake_warehouse" "dev_wh" {
  name           = "DEV_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

resource "snowflake_database" "dev" {
  name = "DEV"
}

resource "snowflake_account_role" "dev_role" {
  name = "DEV_ROLE"
}

resource "snowflake_user" "dev_user" {
  name              = var.dev_user_name
  login_name        = var.dev_user_name
  password          = var.dev_user_password
  default_role      = snowflake_account_role.dev_role.name
  default_warehouse = snowflake_warehouse.dev_wh.name
}

resource "snowflake_grant_account_role" "dev_role_to_user" {
  role_name = snowflake_account_role.dev_role.name
  user_name = snowflake_user.dev_user.name
}

########################################
# Permissions
########################################

# Warehouse usage
resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  account_role_name = snowflake_account_role.dev_role.name
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.dev_wh.name
  }
}

# Full control of DEV database
resource "snowflake_grant_privileges_to_account_role" "dev_db_all" {
  account_role_name = snowflake_account_role.dev_role.name
  privileges        = ["ALL PRIVILEGES"]

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.dev.name
  }
}

# Existing schemas in DEV
resource "snowflake_grant_privileges_to_account_role" "dev_all_existing_schemas" {
  account_role_name = snowflake_account_role.dev_role.name
  privileges        = ["USAGE", "CREATE TABLE", "CREATE VIEW"]

  on_schema {
    all_schemas_in_database = snowflake_database.dev.name
  }
}

########################################
# dbt Cloud minimal setup
########################################

resource "dbtcloud_project" "dev_project" {
  name = var.dbt_project_name
}

resource "dbtcloud_global_connection" "snowflake_dev" {
  name = "Snowflake DEV"

  snowflake = {
    account   = "${var.snowflake_organization_name}-${var.snowflake_account_name}"
    database  = snowflake_database.dev.name
    warehouse = snowflake_warehouse.dev_wh.name
    role      = snowflake_account_role.dev_role.name
  }
}

resource "dbtcloud_snowflake_credential" "dev" {
  project_id  = dbtcloud_project.dev_project.id
  auth_type   = "password"
  num_threads = 4

  user      = var.dev_user_name
  password  = var.dev_user_password
  database  = snowflake_database.dev.name
  warehouse = snowflake_warehouse.dev_wh.name
  role      = snowflake_account_role.dev_role.name
  schema    = "PUBLIC"
}

resource "dbtcloud_environment" "dev" {
  project_id    = dbtcloud_project.dev_project.id
  name          = "Development"
  type          = "deployment"
  connection_id = dbtcloud_global_connection.snowflake_dev.id
  credential_id = dbtcloud_snowflake_credential.dev.credential_id
}