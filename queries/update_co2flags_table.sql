alter table co2flags
  add column result_housing_total double precision, 
  add column result_grand_total double precision;


-- carbon footprint values are from the CoolClimate API 
-- using downtown Austin zip code 78704
 
update co2flags 
   set result_housing_total = 7.815824,
       result_grand_total = 27.709996
 where num_residents = 0 and
       co2_inc_flag = 2;
         
update co2flags 
   set result_housing_total = 10.335476,
       result_grand_total = 46.340469
 where num_residents = 0 and
       co2_inc_flag = 8;
       
update co2flags 
   set result_housing_total = 12.839948,
       result_grand_total = 61.815252
 where num_residents = 0 and
       co2_inc_flag = 11;      
       
update co2flags 
   set result_housing_total = 6.863444,
       result_grand_total = 22.493412
 where num_residents = 1 and
       co2_inc_flag = 1;
      
update co2flags 
   set result_housing_total = 6.470999, 
       result_grand_total = 18.390375
 where num_residents = 1 and
       co2_inc_flag = 3;       
       
update co2flags 
   set result_housing_total = 7.087217,
       result_grand_total = 21.810253
 where num_residents = 1 and
       co2_inc_flag = 4; 

update co2flags 
   set result_housing_total = 7.850794,
       result_grand_total = 26.401885
 where num_residents = 1 and
       co2_inc_flag = 6; 

update co2flags 
   set result_housing_total = 8.647359,
       result_grand_total = 33.437878
 where num_residents = 1 and
       co2_inc_flag = 8; 

update co2flags 
   set result_housing_total = 9.325487,
       result_grand_total = 36.965321
 where num_residents = 1 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 10.875053,
       result_grand_total = 44.798894
 where num_residents = 1 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 10.647678,  
       result_grand_total = 39.940866
 where num_residents = 2 and
       co2_inc_flag = 1;
       
update co2flags 
   set result_housing_total = 8.003495,
       result_grand_total = 25.961879
 where num_residents = 2 and
       co2_inc_flag = 2;

update co2flags 
   set result_housing_total = 9.190656,
       result_grand_total = 30.624349
 where num_residents = 2 and
       co2_inc_flag = 4;

update co2flags 
   set result_housing_total = 9.955682,
       result_grand_total = 35.92206
 where num_residents = 2 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 10.863542,
       result_grand_total = 42.220753
 where num_residents = 2 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 11.652925,
       result_grand_total = 46.457871
 where num_residents = 2 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 13.41681,
       result_grand_total = 55.922738
 where num_residents = 2 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 11.690701,
       result_grand_total = 45.860941
 where num_residents = 3 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 9.281768,
       result_grand_total = 32.410335
 where num_residents = 3 and
       co2_inc_flag = 4;
       
update co2flags 
   set result_housing_total = 10.929271,
       result_grand_total = 40.50607
 where num_residents = 3 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 11.539793,
       result_grand_total = 45.986043
 where num_residents = 3 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 12.431083,
       result_grand_total = 50.685311
 where num_residents = 3 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 14.340289,
       result_grand_total = 60.894454
 where num_residents = 3 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 12.83674, 
       result_grand_total = 52.426778
 where num_residents = 4 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 9.118715,
       result_grand_total = 33.269886
 where num_residents = 4 and
       co2_inc_flag = 3;

update co2flags 
   set result_housing_total = 11.114875,
       result_grand_total = 42.612792
 where num_residents = 4 and
       co2_inc_flag = 6;

update co2flags 
   set result_housing_total = 12.374838,
       result_grand_total = 51.164468
 where num_residents = 4 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 13.340669,
       result_grand_total = 55.845248
 where num_residents = 4 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 15.454173,
       result_grand_total = 66.289176
 where num_residents = 4 and
       co2_inc_flag = 11;

update co2flags 
   set result_housing_total = 13.678888,
       result_grand_total = 55.824748
 where num_residents = 5 and
       co2_inc_flag = 1;

update co2flags 
   set result_housing_total = 13.163276,
       result_grand_total = 53.244163
 where num_residents = 5 and
       co2_inc_flag = 8;

update co2flags 
   set result_housing_total = 14.079959,
       result_grand_total = 58.399131
 where num_residents = 5 and
       co2_inc_flag = 9;

update co2flags 
   set result_housing_total = 15.934765,
       result_grand_total = 69.663126
 where num_residents = 5 and
       co2_inc_flag = 11;
  
