use yelpSingleTable;
go

-- d1: Inheritance
select f.type, bf.*, g.name as groupName
from businessFeature bf
inner join feature f on bf.feature = f.name
left join featureGroup g on bf.groupId = g.id;

-- d4: Unbounded Inheritance
select * from business b left join
(select bf.businessId,
        max(case bf.feature when 'Parking' then available end) as feat_parking,
        max(case bf.feature when 'WiFi' then available end) as feat_wifi,
        max(case bf.feature when 'Smoking' then value end) as feat_smoking,
        max(case bf.feature when 'AgesAllowed' then value end) as feat_agesAllowed,
        max(case bf.feature when 'breakfast' then available end) as feat_breakfast_available,
        max(case bf.feature when 'breakfast' then g.name end) as feat_breakfast_groupName
from businessFeature bf
inner join feature f on bf.feature = f.name
left join featureGroup g on bf.groupId = g.id
group by bf.businessId) afs on b.id = afs.businessId;
