# Helper commands to push sample data to snowflake
# Set password once in terminal
export SNOWSQL_PWD='your_password'



# Push to DEV database
snowsql -a QXNBBYZ-US25909 -u MATHIASO3110 <<'EOF'
USE WAREHOUSE DEV_WH;
USE DATABASE DEV;
USE SCHEMA PUBLIC;

-- Clear existing data
TRUNCATE TABLE customers;
TRUNCATE TABLE orders;

-- Clear any previously staged files to avoid accidental loads
REMOVE @%customers;
REMOVE @%orders;

-- Upload and overwrite
PUT file://data/customers1.csv @%customers AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
PUT file://data/orders1.csv    @%orders    AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

-- Load ONLY the files you just uploaded
COPY INTO customers
  FROM @%customers/customers1.csv.gz
  FILE_FORMAT = (TYPE=CSV FIELD_DELIMITER=';' SKIP_HEADER=1);

COPY INTO orders
  FROM @%orders/orders1.csv.gz
  FILE_FORMAT = (TYPE=CSV FIELD_DELIMITER=';' SKIP_HEADER=1);
EOF




# Push to PROD database
snowsql -a QXNBBYZ-US25909 -u MATHIASO3110 <<'EOF'
USE WAREHOUSE PROD_WH;
USE DATABASE PROD;
USE SCHEMA PUBLIC;

-- Clear existing data
TRUNCATE TABLE customers;
TRUNCATE TABLE orders;

-- Clear any previously staged files to avoid accidental loads
REMOVE @%customers;
REMOVE @%orders;

-- Upload and overwrite
PUT file://data/customers1.csv @%customers AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
PUT file://data/orders1.csv    @%orders    AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

-- Load ONLY the files you just uploaded
COPY INTO customers
  FROM @%customers/customers1.csv.gz
  FILE_FORMAT = (TYPE=CSV FIELD_DELIMITER=';' SKIP_HEADER=1);

COPY INTO orders
  FROM @%orders/orders1.csv.gz
  FILE_FORMAT = (TYPE=CSV FIELD_DELIMITER=';' SKIP_HEADER=1);
EOF


