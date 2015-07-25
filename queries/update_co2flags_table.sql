alter table co2flags
  add column result_housing_total double precision, 
  add column result_grand_total double precision;


-- carbon footprint values are from the CoolClimate API 
-- using downtown Austin zip code 78701
 
update co2flags 
   set result_housing_total = 6.653839,
       result_grand_total = 25.269194
 where num_residents = 0 and
       co2_inc_flag = 2;
         
update co2flags 
   set result_housing_total = 8.893162,
       result_grand_total = 42.013681
 where num_residents = 0 and
       co2_inc_flag = 8;
       
update co2flags 
   set result_housing_total = 11.047004,
       result_grand_total = 56.686517
 where num_residents = 0 and
       co2_inc_flag = 11;      
       
update co2flags 
   set result_housing_total = 5.941989,
       result_grand_total = 20.453935
 where num_residents = 1 and
       co2_inc_flag = 1;
      
update co2flags 
   set result_housing_total = 5.549544,
       result_grand_total = 16.700272
 where num_residents = 1 and
       co2_inc_flag = 3;       
       
update co2flags 
   set result_housing_total = 6.105629,
       result_grand_total = 19.71143
 where num_residents = 1 and
       co2_inc_flag = 4; 

update co2flags 
   set result_housing_total = 6.698975,
       result_grand_total = 23.786761
 where num_residents = 1 and
       co2_inc_flag = 6; 

update co2flags 
   set result_housing_total = 7.445574,
       result_grand_total = 30.574168
 where num_residents = 1 and
       co2_inc_flag = 8; 

update co2flags 
   set result_housing_total = 8.063569,
       result_grand_total = 33.915004
 where num_residents = 1 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 9.442904,
       result_grand_total = 41.378415
 where num_residents = 1 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 9.085098,
       result_grand_total = 36.255856
 where num_residents = 2 and
       co2_inc_flag = 1;
       
update co2flags 
   set result_housing_total = 6.841511,
       result_grand_total = 23.559619
 where num_residents = 2 and
       co2_inc_flag = 2;

update co2flags 
   set result_housing_total = 7.798307,
       result_grand_total = 27.612908
 where num_residents = 2 and
       co2_inc_flag = 4;

update co2flags 
   set result_housing_total = 8.513367,
       result_grand_total = 32.459782
 where num_residents = 2 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 9.300963,
       result_grand_total = 38.185092
 where num_residents = 2 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 9.980247,
       result_grand_total = 42.212692
 where num_residents = 2 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 11.563734,
       result_grand_total = 51.188835
 where num_residents = 2 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 9.95789,
       result_grand_total = 41.45907
 where num_residents = 3 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 7.939386,
       result_grand_total = 29.14273
 where num_residents = 3 and
       co2_inc_flag = 4;
       
update co2flags 
   set result_housing_total = 9.296392,
       result_grand_total = 36.306602
 where num_residents = 3 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 9.806982,
       result_grand_total = 41.32471
 where num_residents = 3 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 10.578007,
       result_grand_total = 45.693636
 where num_residents = 3 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 12.256849,
       result_grand_total = 55.369011
 where num_residents = 3 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 10.933697,
       result_grand_total = 47.467389
 where num_residents = 4 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 7.726367,
       result_grand_total = 29.971779
 where num_residents = 4 and
       co2_inc_flag = 3;

update co2flags 
   set result_housing_total = 9.43203,
       result_grand_total = 38.202207
 where num_residents = 4 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 10.581895,
       result_grand_total = 46.085325
 where num_residents = 4 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 11.377494,
       result_grand_total = 50.477992
 where num_residents = 4 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 13.210668,
       result_grand_total = 60.29172
 where num_residents = 4 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 11.595449,
       result_grand_total = 50.548217
 where num_residents = 5 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 11.200101,
       result_grand_total = 47.970158
 where num_residents = 5 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 11.946553,
       result_grand_total = 52.721657
 where num_residents = 5 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 13.631128,
       result_grand_total = 63.347062
 where num_residents = 5 and
       co2_inc_flag = 11;
  
