--load the data from S3 and define the schema
raw = LOAD '/user/hadoop/data2.csv' USING PigStorage(',') AS  (date, type:chararray, parl:int, prov:chararray, riding:chararray, lastname:chararray, firstname:chararray,gender:chararray, occupation:chararray, party:chararray,votes:int, percent:double, elected:int);

--some data entries use the middle name as well, so this way we will catch all of them
fltrd = FILTER raw by votes < 100;

SPLIT fltrd INTO winners IF elected == 1, losers IF elected == 0;

elections = JOIN winners BY date, losers BY date;

vote_differences = foreach elections generate winners, losers, (winners.votes-losers.votes) as vote_difference:int;

elections_c = FILTER vote_differences by vote_difference < 10;
--print the result tuple to the screen

dump elections_c;