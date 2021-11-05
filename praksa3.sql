select *
from tab3

select propertyaddress 
from tab3
where propertyaddress is null
order by parcelid;


select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
from tab3 a
join tab3 b
    on a.parcelid = b.parcelid
    and a.uniqueid_ <> b.uniqueid_ 
where a.propertyaddress  is null;


update (select a.PropertyAddress as ad1, b.PropertyAddress as ad2, coalesce(a.PropertyAddress, b.PropertyAddress) as ad3, a.ParcelID, b.ParcelID
    from tab3 a
    join tab3 b 
        on a.ParcelID=b.ParcelID
        AND a.UniqueID_ <> b.UniqueID_
        where a.PropertyAddress is null
        )m
    set m.ad1=m.ad3;
    

UPDATE tab3 a
    SET PropertyAddress = (SELECT MAX(b.PropertyAddress)
                   FROM tab3 b
                   WHERE a.ParcelID = b.ParcelID AND
                          b.PropertyAddress IS NOT NULL
                  )
    WHERE PropertyAddress IS NULL ;
    
    
select *
from tab3
where ParcelID='034 07 0B 015.00'

--razdvajanje adrese

select 
    substr(PropertyAddress, 1, instr(PropertyAddress, ',')-1) as Address
    ,substr(PropertyAddress, instr(PropertyAddress, ',')+1, length(PropertyAddress)) as Address1
    from tab3
        
        
        
alter table tab3
add PropertySplitAddress Varchar2(255);

update tab3
SET PropertySplitAddress = substr(PropertyAddress, 1, instr(PropertyAddress, ',')-1)

alter table tab3
add PropertySplitCity Varchar2(255);

update tab3
SET PropertySplitCity = substr(PropertyAddress, instr(PropertyAddress, ',')+1, length(PropertyAddress))

select *
from tab3

--razdvajanje adrese vlasnika

select REGEXP_SUBSTR(owneraddress, '[^,]+', 1,1) as address,
REGEXP_SUBSTR(owneraddress, '[^,]+', 1,2) as city,
REGEXP_SUBSTR(owneraddress, '[^,]+', 1,3) as country
from tab3;

alter table tab3
add owner_split_address varchar2(128);

update tab3
set owner_split_address = REGEXP_SUBSTR(owneraddress, '[^,]+', 1,1);

alter table tab3
add owner_split_city varchar2(128);

update tab3
set owner_split_city = REGEXP_SUBSTR(owneraddress, '[^,]+', 1,2);

alter table tab3
add owner_split_state varchar2(128);

update tab3
set owner_split_state = REGEXP_SUBSTR(owneraddress, '[^,]+', 1,3);


-- promjena Y i N u Yes i No

select distinct soldasvacant, count(soldasvacant)
from tab3
group by soldasvacant
order by 2;

select soldasvacant,
CASE when soldasvacant = 'Y' Then 'Yes'
    when soldasvacant = 'N' Then 'No'
    ELSE soldasvacant
    END
from tab3;

update tab3
set soldasvacant = CASE when soldasvacant = 'Y' Then 'Yes'
    when soldasvacant = 'N' Then 'No'
    ELSE soldasvacant
    END;


--brisanje duplikata

delete from tab3  
where uniqueid_ in (select uniqueid_ from ( SELECT
    uniqueid_,
    parcelid,
    propertyaddress,
    saleprice,
    saledate,
    legalreference,
    ROW_NUMBER()
    OVER(PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
         ORDER BY
             uniqueid_
    ) row_num
FROM
    tab3
)
WHERE row_num > 1
);

-- brisanje kolona

alter table tab3
drop (owneraddress, taxdistrict, propertyaddress);

select * from tab3;



