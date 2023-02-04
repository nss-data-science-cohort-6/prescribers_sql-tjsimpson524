1.

Select npi, SUM(total_claim_count) AS total_claims
From prescription
Group By npi
Order By total_claims Desc;


Select 
	nppes_provider_first_name,
	nppes_provider_last_org_name,
	Sum(total_claim_count) As total_claims
From prescription
Inner Join prescriber
Using (npi)
Group by npi, nppes_provider_first_name, nppes_provider_last_org_name
Order By total_claims Desc;


2.

Select 
	specialty_description,
	Sum(total_claim_count) As total_claims
From prescription
Inner Join prescriber
Using(npi)
Inner Join(
Select Distinct drug_name,
	opioid_drug_flag
	From drug
	) sub
	Using(drug_name)
	Where opioid_drug_flag = 'Y'
Group By specialty_description
Order By total_claims Desc;

C.

Select 
		specialty_description,
		Count(total_claim_count)
From prescriber
Left Join prescription
Using (npi)
Group By specialty_description
Having Count(total_claim_count) = 0;

D. **

3. 

Select generic_name,
		Sum(total_drug_cost) :: money As total_drug_cost
From prescription
Inner Join drug
Using(drug_name)
Group by generic_name
Order by total_drug_cost Desc;



Select
generic_name,
Sum(total_drug_cost)::money AS total_cost,
Sum(total_day_supply) as total_supply,
Sum(total_drug_cost)::money/Sum(total_day_supply) As cost_per_day
From prescription
Inner Join  drug
Using(drug_name)
Group By generic_name
Order By cost_per_day Desc;

4.

-- (Select  drug_name,
-- 		'opioid' as drug_type
		
-- From drug
-- Where opioid_drug_flag = 'Y')

-- Union

-- (Select  drug_name,
-- 		'antibiotic' as drug_type
		
-- From drug
-- Where antibiotic_drug_flag = 'Y')
-- Union
-- (Select  drug_name,
-- 		'neither' as  drug_type
-- From drug
-- Where opioid_drug_flag = 'N' And antibiotic_drug_flag = 'N')
-- Order by drug_name


Select drug_name,
	Case When opioid_drug_flag = 'Y' Then 'opioid'
	When antibiotic_drug_flag = 'Y' Then 'antibiotic'
	Else 'neither'
	End as drug_type
From drug
Order by drug_name


B.

Select drug_name, 
	Case When opioid_drug_flag = 'Y' Then 'opioid'
	When antibiotic_drug_flag = 'Y' Then 'antibiotic'
	Else 'neither'
	End as drug_type
From drug
Inner Join prescription
Using (drug_name)

Order by drug_name

-- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
SELECT (CASE WHEN opioid_drug_flag = 'Y' OR long_acting_opioid_drug_flag = 'Y' THEN 		                      'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
        END) AS drug_type,
	    SUM(total_drug_cost) ::money AS total_cost
FROM drug
INNER JOIN prescription
USING(drug_name)
GROUP BY (CASE WHEN opioid_drug_flag = 'Y' OR long_acting_opioid_drug_flag = 'Y' THEN 		                     'opioid'
          WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
          ELSE 'neither'
          END)
ORDER BY total_cost DESC;


5. 

Select Count(cbsa)
from cbsa
Inner Join fips_county
Using(fipscounty)
Where state = 'TN'

5B.

SELECT county, population
FROM fips_county
INNER JOIN population
USING(fipscounty)
GROUP BY county, population
ORDER BY population Desc;

5c.

SELECT county, population
FROM fips_county
INNER JOIN population
USING(fipscounty)
WHERE fipscounty NOT IN 
                       (SELECT fipscounty
					    FROM cbsa)
GROUP BY county, population
ORDER BY population ASC;

6.

Select total_claim_count 
From prescription
Where total_claim_count >= 3000




