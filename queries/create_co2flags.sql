create table co2flags (
  dataid character varying, 
  num_residents integer, 
  co2_inc_flag integer);
  
create index co2flags_idx on co2flags using btree (dataid);