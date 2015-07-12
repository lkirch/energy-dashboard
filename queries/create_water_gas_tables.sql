create table water_capstone (dataid integer, localminute timestamp with time zone, consumption numeric(10,3));
create index water_capstone_dataid_idx on water_capstone using btree (dataid);
create index water_capstone_localminute_idx on water_capstone using btree (localminute);


create table water_ert (dataid integer, readtime timestamp with time zone, meter_value numeric);
create index water_ert_dataid_readtime_idx on water_ert using btree (dataid, readtime);


create table gas_ert (dataid integer, readtime timestamp with time zone, meter_value numeric);
create index gas_ert_dataid_readtime_idx on gas_ert using btree (dataid, readtime);


\copy gas_ert from '/usr/data/gas_ert.csv' WITH CSV HEADER DELIMITER AS ';';
\copy water_capstone from '/usr/data/water_capstone.csv' WITH CSV HEADER DELIMITER AS ';';
\copy water_ert from '/usr/data/water_ert.csv' WITH CSV HEADER DELIMITER AS ';';
