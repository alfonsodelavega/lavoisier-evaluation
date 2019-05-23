use yelpConcreteTable;
go

-- d2: Inheritance
select 'AvailableFeature' as type, af.feature, af.available, null as value, null as groupName
from availableFeature af

union all

select 'ValuedFeature' as type, vf.feature, null, vf.value, null
from valuedFeature vf

union all

select 'GroupedFeature' as type, gf.feature, gf.available, null, g.name
from groupedFeature gf inner join featureGroup g on gf.groupId=g.id;

-- d5: Unbounded Inheritance
select * from business b left join
(select af.businessId,
        max(case af.feature when 'Parking' then available end) as feat_parking,
        max(case af.feature when 'WiFi' then available end) as feat_wifi
from availableFeature af
group by af.businessId) afs on b.id = afs.businessId

left join

(select vf.businessId,
        max(case vf.feature when 'Smoking' then value end) as feat_smoking,
        max(case vf.feature when 'AgesAllowed' then value end) as feat_agesAllowed
from valuedFeature vf
group by vf.businessId) vfs on b.id = vfs.businessId

left join

(select gf.businessId,
        max(case gf.feature when 'breakfast' then available end) as feat_breakfast_available,
        max(case gf.feature when 'breakfast' then g.name end) as feat_breakfast_groupName
from groupedFeature gf
inner join featureGroup g on gf.groupId = g.id
group by gf.businessId, g.name) gfs on b.id = gfs.businessId;
