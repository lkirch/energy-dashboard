SELECT *
  FROM university.electricity_egauge_minutes
  WHERE localminute >= '2014-01-01 00:00:00'
    AND localminute < '2015-01-01 00:00:00'
    AND dataid = 94