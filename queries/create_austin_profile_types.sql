-- Adding in profile_type to the metadata table

UPDATE metadata
  SET profile_type = 0;

-- 495 records in the metadata table are not Austin
-- 176 records are Austin and Apartment
--  33 records are Austin and Town Home
-- 186 records are Austin, Single-Family Home and < 2000 sq ft
-- 160 records are Austin, Single-Family Home and 2000 - 2999 sq ft
--  52 records are Austin, Single-Family Home and > 3000 sq ft

UPDATE metadata SET profile_type = 1 WHERE dataid IN
  (SELECT dataid from metadata where city='Austin' AND building_type='Single-Family Home' AND total_square_footage !='NA' AND CAST(total_square_footage AS NUMERIC) >= 2000 AND CAST(total_square_footage AS NUMERIC) < 3000);

UPDATE metadata SET profile_type = 2 WHERE dataid IN
  (SELECT dataid from metadata where city='Austin' AND building_type='Single-Family Home' AND total_square_footage !='NA' AND CAST(total_square_footage AS NUMERIC) < 2000);
  
UPDATE metadata SET profile_type = 3 WHERE dataid IN  
  (SELECT dataid from metadata where city='Austin' AND building_type='Single-Family Home' AND total_square_footage !='NA' AND CAST(total_square_footage AS NUMERIC) > 3000);
  
UPDATE metadata SET profile_type = 4 WHERE dataid IN
  (SELECT dataid from metadata where city='Austin' AND building_type='Apartment');
  
UPDATE metadata SET profile_type = 4 WHERE dataid IN
  (SELECT dataid from metadata where city='Austin' AND building_type='Town Home');  
