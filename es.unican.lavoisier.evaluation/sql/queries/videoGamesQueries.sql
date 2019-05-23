use videoGames;
go

-- a: Single table/class
select * from videoGame;

-- b2: Single-bounded reference
select a.*, v.name as videoGameName, v.price, v.launchDate, v.publisherId
from Achievement a
inner join videoGame v on v.id = a.videoGameId;

-- c2: Unbounded reference
select v.id, v.name, v.launchDate, v.price,
       max(case tl.[language] when 'English' then 1 else 0 end) as EnglishTexts,
       max(case tl.[language] when 'French' then 1 else 0 end) as FrenchTexts,
       max(case tl.[language] when 'Spanish' then 1 else 0 end) as SpanishTexts
from videoGame v
right join textLanguage tl on v.id = tl.videoGameId
group by v.id, v.name, v.launchDate, v.price;

-- e1: Combination (multiple)
select v.id, v.name, v.launchDate, v.price,
       p.name as publisher,
       max(case gt.tag when 'Survival' then 1 else 0 end) as tag_Survival,
       max(case gt.tag when 'Singleplayer' then 1 else 0 end) as tag_Singleplayer,
       max(case gt.tag when 'Indie' then 1 else 0 end) as tag_indie
from videoGame v
inner join publisher p on v.publisherId = p.id
right join gameTag gt on v.id = gt.videoGameId
group by v.id, v.name, v.launchDate, v.price;
