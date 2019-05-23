use yelpClassTable;
go

-- d3: Inheritance
select 'AvailableFeature' as type, f.name, af.available, null as value, null as groupName
from availableFeature af
inner join feature f on af.feature = f.name

union all

select 'ValuedFeature' as type, f.name, null, vf.value, null
from valuedFeature vf
inner join feature f on vf.feature = f.name

union all

select 'GroupedFeature' as type, f.name, gf.available, null, g.name
from groupedFeature gf
inner join feature f on gf.feature = f.name
inner join featureGroup g on gf.g_id=g.id;

-- d6: Unbounded Inheritance
select * from business b left join
(select af.businessId,
        max(case f.name when 'Parking' then available end) as feature_parking,
        max(case f.name when 'WiFi' then available end) as feature_wifi
from availableFeature af
inner join feature f on af.feature = f.name
group by af.businessId) afs on b.id = afs.businessId

left join

(select vf.businessId,
        max(case f.name when 'Smoking' then value end) as feature_smoking,
        max(case f.name when 'AgesAllowed' then value end) as feature_agesAllowed
from valuedFeature vf
inner join feature f on vf.feature = f.name
group by vf.businessId) vfs on b.id = vfs.businessId

left join

(select gf.businessId,
        max(case f.name when 'breakfast' then available end) as feature_breakfast_available,
        max(case f.name when 'breakfast' then g.name end) as feature_breakfast_groupName
from groupedFeature gf
inner join feature f on gf.feature = f.name
inner join featureGroup g on gf.g_id = g.id
group by gf.businessId, g.name) gfs on b.id = gfs.businessId;
