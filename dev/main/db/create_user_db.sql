# This scrip creates the user and the needed databases

CREATE DATABASE pcs;
CREATE DATABASE pcs_test;
CREATE DATABASE pcs_production;

GRANT ALL ON pcs.* TO pcs@localhost IDENTIFIED BY '1234';
GRANT ALL ON pcs_test.* TO pcs@localhost IDENTIFIED BY '1234';
GRANT ALL ON pcs_production.* TO pcs@localhost IDENTIFIED BY '1234';

FLUSH PRIVILEGES;

