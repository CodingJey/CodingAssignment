CREATE TABLE companies (
id SERIAL PRIMARY KEY,
name VARCHAR(255),
website VARCHAR(255),
address TEXT,
source VARCHAR(50), -- Es: 'API_1', 'SCRAPER_2', 'MANUAL'
inserted_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE normalized_companies (
id SERIAL PRIMARY KEY,
name VARCHAR(255) UNIQUE,
canonical_website VARCHAR(255),
address TEXT
);

-- Task 1
SELECT 
    LOWER(name) AS normalized_name,
    COUNT(*) AS occurrence_count,
    ARRAY_AGG(DISTINCT source) AS sources
FROM companies
GROUP BY LOWER(name)
HAVING COUNT(*) >= 1;


-- Task 2  
WITH ranked AS (
  SELECT
    c.*,
    ROW_NUMBER() OVER (
      PARTITION BY LOWER(name)
      ORDER BY 
        CASE 
          WHEN source = 'MANUAL' THEN 1
          WHEN source LIKE 'API%' THEN 2
          WHEN source LIKE 'SCRAPER%' THEN 3
          ELSE 4
        END
    ) AS rn
  FROM companies c
)
INSERT INTO normalized_companies (name, canonical_website, address)
SELECT name, website, address
FROM ranked
WHERE rn = 1;


-- Task 3
SELECT 
    name, 
    COUNT(*) AS company_count
FROM companies
GROUP BY name
ORDER BY company_count DESC;





select * from normalized_companies;

select * from companies;

TRUNCATE TABLE companies RESTART IDENTITY;
TRUNCATE TABLE normalized_companies RESTART IDENTITY;

-- Data Generated to reflect supposed real world data
INSERT INTO public.companies (id, "name", website, address, "source", inserted_at)
VALUES
  (nextval('companies_id_seq'::regclass), 'Acme Corp', 'www.acmecorp.com', '123 Acme Way', 'MANUAL', now()),
  (nextval('companies_id_seq'::regclass), 'Acme Corp', 'www.acmecorp.com', '123 Acme Way', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Company 2', 'www.company2.com', 'Address 2', 'API', now()),
  (nextval('companies_id_seq'::regclass), 'Company 3', 'www.company3.com', 'Address 3', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Globex Inc', 'www.globex.com', '456 Globex Plaza', 'MANUAL', now()),
  (nextval('companies_id_seq'::regclass), 'Globex Inc', 'www.globex.com', '456 Globex Plaza', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Company 5', 'www.company5.com', 'Address 5', 'API', now()),
  (nextval('companies_id_seq'::regclass), 'Company 6', 'www.company6.com', 'Address 6', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Umbrella Corp', 'www.umbrellacorp.com', '789 Umbrella Street', 'MANUAL', now()),
  (nextval('companies_id_seq'::regclass), 'Umbrella Corp', 'www.umbrellacorp.com', '789 Umbrella Street', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Company 8', 'www.company8.com', 'Address 8', 'API', now()),
  (nextval('companies_id_seq'::regclass), 'Company 9', 'www.company9.com', 'Address 9', 'SCRAPER', now()),
  (nextval('companies_id_seq'::regclass), 'Initech', 'www.initech.com', '101 Initech Blvd', 'MANUAL', now()),
  (nextval('companies_id_seq'::regclass), 'Initech', 'www.initech.com', '101 Initech Blvd', 'SCRAPER', now());

