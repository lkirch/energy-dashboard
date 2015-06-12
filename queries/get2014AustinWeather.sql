SELECT 
  *
FROM 
  university.weather
WHERE
  weather.latitude = 30.292432
    AND 
  weather.longitude = -97.699662
    AND
  weather.localhour >= '2014-01-01 00:00:00'
    AND localhour < '2015-01-01 00:00:00';