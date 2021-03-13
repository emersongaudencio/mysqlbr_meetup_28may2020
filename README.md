# mysqlbr_meetup_28may2020
Cross-database platform migration (Oracle to MariaDB using SQLines)

### SQLines will be installed and used on a intermediate machine to be a bridge between Oracle to MariaDB.

## Proposed Scenario

* Intermediate machine for SQLines
* Oracle source database
* MariaDB target database

e.g:

```
  Source Database                  *Migration host*                 Target Database
+------------------+             +------------------+             +------------------+
|                  |             |      SQLines     |             |                  |
| Oracle Database  | <=========> |   intermediate   | <=========> | MariaDB Database |
|                  |             |      host        |             |                  |
+------------------+             +------------------+             +------------------+
```

## Links and references:
* [SQLines](http://www.sqlines.com/sqldata)

* [SymmetricDS](https://www.symmetricds.org/)

* [Blitzz.io](https://www.blitzz.io/developers)

* [Blitzz.io Docker Image](https://hub.docker.com/r/blitzzreplicant/replicant)

* [Amazon DMS](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Introduction.htm)

* [Amazon Schema convertion tool](https://aws.amazon.com/dms/schema-conversion-tool/)

* [Oracle Golden Gate](https://docs.oracle.com/goldengate/1212/ggwinux/GWUAD/wu_about_gg.htm#GWUAD110)

* [Oracle to MariaDB Migration - Oracle Compatibility Mode](http://www.sqlines.com/oracle-to-mariadb-compatibility)

* [Oracle to MariaDB Migration](http://www.sqlines.com/oracle-to-mariadb)

### Install SQLines on Linux (CentOS/Redhat/AmazonLinux)
```
sh install_ansible_sqlines.sh
```

### 1rst - How to setup SQLines on Linux
```
[root@srv-sqlines ~]# sudo su - mysqlines
[mysqlines@srv-sqlines ~]$ ls
```

### output from above commands
```
[mysqlines@srv-sqlines ~]$ ls
instantclient_12_2                            instantclient-sqlplus-linux.x64-12.2.0.1.0.zip  oradiag_mysql                  sqlinesdata31777_x86_64_linux.tar.gz
instantclient-basic-linux.x64-12.2.0.1.0.zip  instantclient-tools-linux.x64-12.2.0.1.0.zip    sqlinesdata31777_x86_64_linux  tnsnames.ora
```

### 2nd - Setup oracle datasource using tnsnames.ora file
```
[mysqlines@srv-sqlines ~]$ vi tnsnames.ora
```

```
XE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.122.250)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XE)
    )
  )
```

### 3rd - Test connection between source and target databases

E.g for Oracle:
```
sqlplus CEP/teste123@XE
```

E.g for MariaDB/MySQL:
```
mysql --user=app_user --password=test123 --host=172.16.122.128 --port=3306
```

PS: keep in ming that you have to be able to connect on the source and target databases from the intermediate machine that we are using to migrate our data from oracle to mariadb

### 4th - How to use sqldata from SQLines

```
./sqldata -sd=oracle,CEP/teste123@XE -td=mariadb,app_user/test123@172.16.122.128,CEP -t=*.* -ss=6 -out=/home/mysqlines -log=migration_cep.log -mysql_set_foreign_key_checks=0
```

PS: keep an eye on the sqldata.cfg file to setup the defaults related to the source and target databases

E.g:
```
[mysqlines@srv-sqlines sqlinesdata31777_x86_64_linux]$ cat sqldata.cfg
-- SQLines Data options (contact us at support@sqlines.com to request a new option)

-- DDL Options
--------------

-- Set yes to to migrate table definitions, or no to not migrate
-- DDL statements executed depends on -topt option (CREATE; DROP and CREATE TABLE, or TRUNCATE TABLE)
-ddl_tables=

-- Set yes to to migrate constraints (this is default), or no to not migrate
-constraints=

-- Set yes to to migrate indexes (this is default), or no to not migrate
-indexes=

-- Data Options
---------------

-- Set yes to to migrate data (this is default), or no to not migrate
-data=

-- The maximum number of rows in read/write batch, by default it is defined by the buffer size divided by the table row size
-batch_max_rows=10000

-- Work with LOBs as VARCHAR columns to increase performance (use if LOB columns contain short values less than a few MB i.e.), default is no
-fetch_lob_as_varchar=

-- Fixed size buffer in bytes to read LOB values by binding not by reading part by part (can cause truncation error if the buffer is less than
-- the maximum LOB value, default is to read LOBs by separate calls
-lob_bind_buffer=1000000

-- When converting from ASCII or UTF16/UCS-2 character sets in the source database to UTF8 i.e. in the target database depending on
-- the actual data you may need greater storage size. And vice versa converting in opposite direction you may require smaller storage size.
-- This parameter specifies the length change ratio. If the source length is 100, and ratio is 1.1 then the target length will be 110
-char_length_ratio=

-- MariaDB options
------------------

-- Path to MariaDB library including the file name. For example, for MariaDB Connector C on Windows:
--   -mariadb_lib=C:\Program Files\MariaDB\MariaDB Connector C 64-bit\lib\libmariadb.dll
-- By default, on Windows the tool tries to load libmariadb.dll library from PATH; if not found the tool tries to use MySQL connector libmysql.dll
-mariadb_lib=

-- Disable or enable binary logging for the connection (the client must have the SUPER privilege for this operation). By default, MariaDB default is used.
-mariadb_set_sql_log_bin=0

-- Run SET UNIQUE_CHECKS=value at the beginning of each session, not executed if no value set (MariaDB as target)
-mariadb_set_unique_checks=0

-- Set global max_allowed_packet option to the specified value (use only values in multiples of 1024, for example, 1073741824 for 1GB)
-- Use this option when you receive 'MySQL has gone away' error during the data load
-mariadb_max_allowed_packet=

-- MySQL options
----------------

-- Set the character set for the connection (utf8 i.e.)
-mysql_set_character_set=utf8mb4

-- Set the collation for the connection
-mysql_set_collation=utf8mb4_bin

-- Run SET FOREIGN_KEY_CHECKS=value at the beginning of each session, not executed if no value set (MySQL as target)
-mysql_set_foreign_key_checks=0

-- Collate used for data validation. Use _bin or _cs collates to order values ABCabc instead of AaBbCc
-mysql_validation_collate=latin1_bin

-- SQL Server options
---------------------

-- Codepage for input data (BCP -C option)
-bcp_codepage=

-- Oracle options
-----------------

-- Path to Oracle OCI library including the file name. For example, for Oracle on Windows:
--   -oci_lib=C:\oraclexe\app\oracle\product\11.2.0\server\bin\oci.dll
-- By default, on Windows the tool tries to load oci.dll library from PATH; if not found the tool tries to search Windows registry to find Oracle client installations
-- See also http://www.sqlines.com/sqldata_oracle_connection
-oci_lib=

-- NLS_LANG setting to use for Oracle connection
-oracle_nls_lang=

-- PostgreSQL options
---------------------

-- Set client encoding (you can also use PGCLIENTENCODING environment variable)
-pg_client_encoding=latin1

-- Sybase ASE options
---------------------

-- Codepage
-sybase_codepage=cp850

-- Set to yes to use encrypted password handshakes with the server
-sybase_encrypted_password=

-- Sybase ASA (Sybase SQL Anywhere) options
-------------------------------------------

-- Set to yes to extract all character data as 2-byte Unicode (UTF-16/UCS-2)
-sybase_asa_char_as_wchar=

-- Informix options
-------------------

-- Set CLIENT_LOCALE for connection (Note that Setnet32 and environment variable has no effect on Informix ODBC driver)
-informix_client_locale=

-- Validation Options
---------------------

-- Maximum number of found not equal rows per table after which the validation stops for this table, by default no limit set
-validation_not_equal_max_rows=

-- Number of digits in the fractional part (milliseconds, microseconds i.e.) of datetime/timestamp values to validate. By default, all digits are compared
-validation_datetime_fraction=

-- Misc Options
---------------

-- Set to yes to generate trace file sqldata.trc with debug information, default is no
-trace=

-- Set to yes to create dump files containing data for tables
-trace_data=

-- Set to yes to create dump files containing differences in data found during data validation
-trace_diff_data=
```

### 5th - Sanity checks to validate the migration from source to destination

There are 2 sanity checks for Oracle and 2 sanity checks for MariaDB

#### ORACLE

```
sqlplus CEP/teste123@XE
sqlplus> @oracle_count_objects.sql;
sqlplus> @oracle_count_rows.sql;
```

E.g output should look like:

```
[mysql@srv-sqlines ~]$ sqlplus CEP/teste123@XE

SQL*Plus: Release 12.2.0.1.0 Production on Mon Jun 1 13:46:31 2020

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL> @oracle_count_objects.sql;

OBJECT_TYPE	      COUNT(1)
------------------- ----------
TABLE			    13
INDEX			    41


BANNER
--------------------------------------------------------------------------------
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
PL/SQL Release 11.2.0.2.0 - Production
CORE	11.2.0.2.0	Production
TNS for 64-bit Windows: Version 11.2.0.2.0 - Production
NLSRTL Version 11.2.0.2.0 - Production


PARAMETER							 VALUE
---------------------------------------------------------------- ----------------------------------------------------------------
NLS_LANGUAGE							 AMERICAN
NLS_TERRITORY							 AMERICA
NLS_CURRENCY							 $
NLS_ISO_CURRENCY						 AMERICA
NLS_NUMERIC_CHARACTERS						 .,
NLS_CALENDAR							 GREGORIAN
NLS_DATE_FORMAT 						 DD-MON-RR
NLS_DATE_LANGUAGE						 AMERICAN
NLS_CHARACTERSET						 AL32UTF8
NLS_SORT							 BINARY
NLS_TIME_FORMAT 						 HH.MI.SSXFF AM
NLS_TIMESTAMP_FORMAT						 DD-MON-RR HH.MI.SSXFF AM
NLS_TIME_TZ_FORMAT						 HH.MI.SSXFF AM TZR
NLS_TIMESTAMP_TZ_FORMAT 					 DD-MON-RR HH.MI.SSXFF AM TZR
NLS_DUAL_CURRENCY						 $
NLS_NCHAR_CHARACTERSET						 AL16UTF16
NLS_COMP							 BINARY
NLS_LENGTH_SEMANTICS						 BYTE
NLS_NCHAR_CONV_EXCP						 FALSE

19 rows selected.

SQL> @oracle_count_rows.sql;
table: LOG_FAIXA_UF --> count: 27
table: LOG_LOCALIDADE --> count: 10698
table: LOG_BAIRRO --> count: 45738
table: LOG_CONTROLE --> count: 1
table: LOG_CPC --> count: 2478
table: LOG_FAIXA_BAIRRO --> count: 92223
table: LOG_FAIXA_CPC --> count: 3698
table: LOG_FAIXA_LOCALIDADE --> count: 367
table: LOG_LOGRADOURO --> count: 909585
table: LOG_UNID_OPER --> count: 15183
table: LOG_FAIXA_UOP --> count: 4627
table: LOG_GRANDE_USUARIO --> count: 11631
table: LOG_TIPO_LOGR --> count: 6
Total rows: 1096262

PL/SQL procedure successfully completed.

SQL>
```

#### MariaDB

```
mysql --user=app_user --password=test123 --host=172.16.122.128 --port=3306
mysql> use cep;
mysql> source /tmp/report_schema_count_rows.sql;
mysql> source /tmp/report_schema.sql;
mysql> call report_schema('cep')\G
mysql> call report_schema_count_rows('cep');
```

E.g output should look like:

```
[mysql@srv-sqlines ~]$ mysql --user=app_user --password=test123 --host=172.16.122.128 --port=3306
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 10.4.13-MariaDB-log MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use cep;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [cep]> source /tmp/report_schema_count_rows.sql;
Query OK, 0 rows affected, 1 warning (0.005 sec)

Query OK, 0 rows affected (0.011 sec)

MariaDB [cep]> source /tmp/report_schema.sql;
Query OK, 0 rows affected, 1 warning (0.002 sec)

Query OK, 0 rows affected (0.006 sec)

MariaDB [cep]> call report_schema('cep')\G
*************************** 1. row ***************************
             DATABASE_NAME: cep
                SIZE_DB_MB: 286.59
              TABLES_COUNT: 13
             INDEXES_COUNT: 54
               VIEWS_COUNT: 0
           FUNCTIONS_COUNT: 0
          PROCEDURES_COUNT: 2
            TRIGGERS_COUNT: 0
              EVENTS_COUNT: 0
DEFAULT_COLLATION_DATABASE: utf8mb4_general_ci
  DEFAULT_CHARSET_DATABASE: utf8mb4
    TOTAL_OBJECTS_DATABASE: 69
1 row in set (0.009 sec)

Query OK, 0 rows affected (0.009 sec)

MariaDB [cep]> call report_schema_count_rows('cep');
+--------------------------+--------------+
| TABLE_NAME               | RECORD_COUNT |
+--------------------------+--------------+
| cep.log_logradouro       |       909585 |
| cep.log_faixa_bairro     |        92223 |
| cep.log_bairro           |        45738 |
| cep.log_unid_oper        |        15183 |
| cep.log_grande_usuario   |        11631 |
| cep.log_localidade       |        10698 |
| cep.log_faixa_uop        |         4627 |
| cep.log_faixa_cpc        |         3698 |
| cep.log_cpc              |         2478 |
| cep.log_faixa_localidade |          367 |
| cep.log_faixa_uf         |           27 |
| cep.log_tipo_logr        |            6 |
| cep.log_controle         |            1 |
+--------------------------+--------------+
13 rows in set (0.681 sec)

+--------------------------+
| TOTAL_DATABASE_RECORD_CT |
+--------------------------+
|                  1096262 |
+--------------------------+
1 row in set (0.681 sec)

Query OK, 13 rows affected (0.681 sec)

MariaDB [cep]>
```
