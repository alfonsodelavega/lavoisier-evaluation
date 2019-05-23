use yelpSingleTable;
go

-- b1: Single-bounded reference
select r.*, u.name as userName
from review r
inner join [user] u on r.userId = u.id;

-- c1: Unbounded reference
select b.id, b.name, b.stars,
       max(case bc.category when 'dj' then 1 else 0 end) as cat_dj,
       max(case bc.category when 'kosher' then 1 else 0 end) as cat_kosher,
       max(case bc.category when 'buffet' then 1 else 0 end) as cat_buffet
from businessCategory bc
right join business b on b.id = bc.businessId
group by b.id, b.name, b.stars;

-- e2: Combination (multilevel)
select r.*, bcats.* from review r
inner join
(select b.id as businessId, b.name as businessName, b.stars as businessStars,
       max(case bc.category when 'vegan' then 1 else 0 end) as cat_vegan,
       max(case bc.category when 'kosher' then 1 else 0 end) as cat_kosher,
       max(case bc.category when 'ecofriendly' then 1 else 0 end) as cat_ecofriendly
from businessCategory bc
right join business b on b.id = bc.businessId
group by b.id, b.name, b.stars) bcats on bcats.businessId = r.businessId;
