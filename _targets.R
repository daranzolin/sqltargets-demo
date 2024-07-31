library(targets)
library(sqltargets)

tar_option_set(
  packages = c(
    "DBI",
    "duckdb"
  ),
  format = "rds"
)

tar_source()

sqltargets_option_set("sqltargets.template_engine", "jinjar")

list(
  tar_target(payment_methods, get_payment_methods()),
  tar_sql(customers_report, "queries/get_customers.sql"),
  tar_sql(payments_report, "queries/get_payments.sql", params = payment_methods)
)
