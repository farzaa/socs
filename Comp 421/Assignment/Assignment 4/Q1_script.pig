--load the data from S3 and define the schema
raw = LOAD '/user/hadoop/data2.csv' USING PigStorage(',') AS  (date, type:chararray, parl:int, prov:chararray, riding:chararray, lastname:chararray, firstname:chararray,gender:chararray, occupation:chararray, party:chararray,votes:int, percent:double, elected:int);

--some data entries use the middle name as well, so this way we will catch all of them
fltrd = FILTER raw by lastname == 'Harper' and firstname matches 'Stephen.*' and percent <= 60;

--project only the needed fields
gen = foreach fltrd generate CONCAT(firstname, CONCAT(' ', lastname));

--choose only the smallest date
results = DISTINCT fltrd;

--print the result tuple to the screen
dump results;
