library(tidyverse)
library(duckdb)

raw_customers <- read_csv("https://raw.githubusercontent.com/dbt-labs/jaffle-shop-classic/main/seeds/raw_customers.csv")
raw_orders <- read_csv("https://raw.githubusercontent.com/dbt-labs/jaffle-shop-classic/main/seeds/raw_orders.csv")
raw_payments <- read_csv("https://raw.githubusercontent.com/dbt-labs/jaffle-shop-classic/main/seeds/raw_payments.csv")

con <- dbConnect(
  duckdb(),
  "jaffle_db.duckdb",
  read_only = FALSE
)

tables <- lst(raw_customers, raw_orders, raw_payments)
walk2(tables, names(tables), \(table, table_name) dbWriteTable(con, table_name, table))
dbDisconnect(con, shutdown = TRUE)
