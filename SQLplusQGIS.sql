/*Create a new table named 'vinice' from the existing table 'sk_druhy_pozemkov', where you determine the area of vinice in square meters for each district. 
In this new 'vinice' table, there will be two attributes: 'kod_okresu' and 'plocha_vinic_m2'. 
Join the table 'hranice_okresy', which contains map data of district boundaries in Slovakia, with the 'vinice' table. 
Create a new table named 'okresy_vinice' that you will display in QGIS. Each student can name the table, for example, 'okresy_vinice_rs'.
In the 'okresy_vinice' table, create a new attribute 'plocha_vinic_ha' and insert the calculated square meters converted to hectares.
In QGIS, categorize districts based on the size of vineyard areas in hectares. Use the database 'dbgis' and the tables 'sk_druhy_pozemkov' and 'hranice_okresy'.*/

CREATE TABLE vinice AS
    SELECT kod_okresu, SUM(vinice_m2) AS plocha_vinic_m2
    FROM sk_druhy_pozemkov 
    GROUP BY kod_okresu;

CREATE TABLE okresy_vinice AS
    SELECT *
    FROM vinice 
    JOIN hranice_okresy  ON  hranice_okresy.idn3 = vinice.kod_okresu;
    
-- "Creation of a new attribute 'plocha_vinic_ha' in the table 'okresy_vinice'."
ALTER TABLE okresy_vinice
ADD COLUMN plocha_vinic_ha numeric;

-- "Updating the new attribute using the conversion from square meters to hectares."
UPDATE okresy_vinice
SET plocha_vinic_ha = plocha_vinic_m2 / 10000;



/*"Select all Slovak peaks with an elevation of 2000 meters or more, including. Also, display their names using the attribute 'nazvysb'; if they don't have a name, do not display them. 
Sort them from the lowest to the highest elevation. Select the attribute with geographic data! In QGIS, create a point layer with symbolization and peak names. 
Choose a suitable basemap, for example, using WMS."*/

SELECT geom, nazvysb, vyska
FROM vyskove_body
WHERE vyska >= 2000 AND nazvysb IS NOT NULL and nazvysb != ''
ORDER BY vyska ASC;


/*"Select all BPEJ (soil-ecological classification units) from the 'bpej' table that belong to the warm very dry basin, continental climatic region, with a gentle slope of 3°–7°, northern exposure, 
with poorly skeletal soils (skeleton content [vol.] in the surface horizon 5–25%), in the subsurface horizon 10–25%, with deep soils (60 cm and more). 
Export the selected BPEJ using the QGIS program, for example, to a SHP file. Use the 'dbgis' database and the 'bpej' table."*/

SELECT * FROM bpej 
WHERE bpej LIKE '04__31_';
