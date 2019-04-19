create database Miscellaneous_db;

use Miscellaneous_db;

select distinct(type)
from birdsong
where country = 'Netherlands';

from birdsong
where latitude between 50 and 60;

select * from birdsong where type like "%song%";

select * from birdsong
where country in ("poland", 'netherlands')

select * from birdsong
where country in ("poland", 'netherlands')

-- find all birds with a genus beninning with the letter 'e'
select * from birdsong where genus like "e%";


-- find all birds south of latitude 60 degrees north
select * from birdsong where latitude <60;


-- find all songs of maing birds
select * from birdsong where type like "%female%" and type like "%male%";


