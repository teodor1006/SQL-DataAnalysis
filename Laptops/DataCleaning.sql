CREATE DATABASE laptop;

USE laptop;

-- Data Cleaning
SELECT *
FROM laptopdata;

RENAME TABLE laptopdata TO laptop;

SELECT * FROM laptop;

-- 1. Create backup
CREATE TABLE laptop_backup LIKE laptop;
INSERT INTO laptop_backup SELECT * FROM laptop;

-- 2. Check number of rows
SELECT *
FROM laptop;

-- 3.Create index of column
ALTER TABLE laptop
ADD COLUMN `index` INT AUTO_INCREMENT PRIMARY KEY 
AFTER `Unnamed: 0`;

SELECT * FROM laptop;

-- 4. Delete unwanted columns
ALTER TABLE laptop
DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptop;

-- 5. Check memory consumption
SELECT DATA_LENGTH/1024 FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'laptop'
AND TABLE_NAME = 'laptop';

-- 6. Drop null values
DELETE FROM laptop
WHERE `index` IN 
(SELECT * FROM (SELECT `index` FROM laptop
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND Weight IS NULL AND Price IS NULL)t);

SELECT COUNT(*) FROM laptop;

-- 7. Drop duplicates
SELECT * FROM laptop 
WHERE `index` NOT IN (
SELECT MIN(`index`) FROM laptop
GROUP BY `index`, Company, TypeName,Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price);

-- 8. Change column data types
-- Inches column 
SELECT * FROM laptop WHERE Inches = '?';
DELETE FROM laptop
WHERE `index` = 480;

ALTER TABLE laptop 
MODIFY Inches decimal(10,1);

-- Ram column 
SET SQL_SAFE_UPDATES=0;

UPDATE laptop l1
SET Ram = (
    SELECT REPLACE(Ram, 'GB', '') 
    FROM (SELECT * FROM laptop) AS l2 
    WHERE l2.index = l1.index
);

ALTER TABLE laptop
MODIFY Ram INT;


-- Weight column
UPDATE laptop l1
SET Weight = (SELECT REPLACE(Weight, 'kg', '') 
              FROM (SELECT * FROM laptop) as l2
              WHERE l2.index = l1.index
);

select * from laptop
where weight = '?';

delete from laptop
where `index` = 100 ;

-- Price column 
UPDATE laptop t1
SET price = (SELECT ROUND(price) 
            FROM (SELECT * FROM laptop) t2
            WHERE t2.index = t1.index);

ALTER TABLE laptop
MODIFY price INT;

-- OpSys column
UPDATE laptop t1
SET OpSys = (
SELECT
CASE 
    WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM (SELECT * FROM laptop) t2
WHERE t2.index = t1.index
);

SELECT * FROM laptop;

-- Gpu column
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptop t1
SET gpu_brand = (SELECT substring_index(Gpu, ' ', 1) 
           FROM (SELECT * FROM laptop) t2
           WHERE t2.index = t1.index);

UPDATE laptop t1
SET gpu_name = (SELECT REPLACE(Gpu, gpu_brand, '') 
               FROM (SELECT * FROM laptop) t2
               WHERE t2.index = t1.index);

ALTER TABLE laptop 
DROP COLUMN Gpu;

SELECT * FROM laptop;

-- Cpu column 
ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

UPDATE laptop t1
SET cpu_brand = (SELECT substring_index(Cpu, ' ', 1) 
                 FROM (SELECT * FROM laptop) t2
                 WHERE t2.index = t1.index
                );

UPDATE laptop t1
SET cpu_speed = (SELECT REPLACE(substring_index(Cpu, ' ', -1), 'GHz', '') 
                 FROM (SELECT * FROM laptop) t2
                 WHERE t2.index = t1.index
                 );
                 
UPDATE laptop t1
SET cpu_name = (SELECT REPLACE(REPLACE(Cpu, cpu_brand, ' '),
                substring_index(REPLACE(Cpu, cpu_brand, ' '), ' ', -1), '')
                FROM (SELECT * FROM laptop) t2
                WHERE t2.index = t1.index);
                
ALTER TABLE laptop 
DROP COLUMN Cpu;


-- Screen resolution
Alter Table laptop
Add Column resolution_width INT AFTER ScreenResolution,
Add Column resolution_height INT AFTER resolution_width;

UPDATE laptop t1
SET resolution_width = (SELECT substring_index(substring_index(ScreenResolution, " ", -1), 'x', 1) 
                        FROM(SELECT * FROM laptop) t2
                        WHERE t2.index = t1.index);
UPDATE laptop t1
SET resolution_height = (SELECT substring_index(substring_index(ScreenResolution, " ", -1), 'x', -1) 
                        FROM (SELECT * FROM laptop) t2
                        WHERE t2.index = t1.index);
                        
Alter Table laptop
Add Column is_touchscreen INT AFTER resolution_height;

UPDATE laptop
SET is_touchscreen = ScreenResolution LIKE '%Touch%';

ALTER TABLE LAPTOP
DROP COLUMN ScreenResolution;

-- Cpu_name column
UPDATE laptop
SET cpu_name = substring_index(trim(cpu_Name), " ", 2);

-- Memory Column
ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INT AFTER memory_type,
ADD COLUMN secondary_storage INT AFTER primary_storage;

UPDATE laptop
SET memory_type = 
CASE
    WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE Null
END;

UPDATE laptop
SET primary_storage = REGEXP_SUBSTR(substring_index(Memory, "+",1), '[0-9]+');

UPDATE laptop
SET secondary_storage = 
CASE
    WHEN Memory LIKE '%+%'
    THEN REGEXP_SUBSTR(trim(substring_index(Memory, "+",-1)), '[0-9]+') 
    ELSE 0 
END;

UPDATE laptop
SET primary_storage = 
CASE
   WHEN primary_storage LIKE 1 THEN 1024
   WHEN primary_storage LIKE 2 THEN 2*1024
   ELSE primary_storage
END;

UPDATE laptop
SET secondary_storage = 
CASE
   WHEN secondary_storage LIKE 1 THEN 1024
   WHEN secondary_storage LIKE 2 THEN 2*1024
   ELSE secondary_storage
END;

ALTER TABLE laptop
DROP COLUMN Memory;

SELECT * from laptop;

SELECT DATA_LENGTH/1024 AS 'Kb' 
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptop' and TABLE_NAME = 'laptop';

SELECT * FROM laptop;

-- Data cleaning ends here 



