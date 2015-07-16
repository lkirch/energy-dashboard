create table austin_profiles (
  dataid character varying, 
  num_residents integer, 
  building_type character varying,
  house_construction_year character varying,
  total_square_footage character varying,
  pv character varying,
  number_of_nests character varying);
  
create index austin_profile_dataid_idx on austin_profiles using btree (dataid);

-- creates the 151 Austin dataids that we have electricity data for 2013 and 2014 
insert into austin_profiles (dataid)
  SELECT distinct metadata.dataid
    FROM metadata
  INNER JOIN electricity_per_minute ON CAST(electricity_per_minute.dataid AS TEXT) = metadata.dataid
  WHERE metadata.city = 'Austin';

-- to remove all rows
-- delete from austin_profiles;

update austin_profiles set num_residents = (select num_residents from metadata where metadata.dataid = austin_profiles.dataid);
update austin_profiles set building_type = (select building_type from metadata where metadata.dataid = austin_profiles.dataid);
update austin_profiles set house_construction_year = (select house_construction_year from metadata where metadata.dataid = austin_profiles.dataid);
update austin_profiles set total_square_footage = (select total_square_footage from metadata where metadata.dataid = austin_profiles.dataid);
update austin_profiles set pv = (select pv from metadata where metadata.dataid = austin_profiles.dataid);
update austin_profiles set number_of_nests = (select number_of_nests from metadata where metadata.dataid = austin_profiles.dataid);