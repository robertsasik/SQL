--"Calculate the areas of parks in hectares within the territory of the city of Žilina."

SELECT priroda.*, CAST(ST_Area(geom) / 10000 AS numeric(10, 2)) AS plocha_v_ha
FROM priroda 
WHERE fclass = 'park'

--"Calculate the total area of all parks in hectares within the territory of the city of Žilina."

SELECT SUM(CAST(ST_Area(geom) / 10000 AS numeric(10, 2))) AS suma_plochy_v_ha 
FROM priroda 
WHERE fclass = 'park';

--"Determine the centroid (center) of the polygon of the city of Žilina."

SELECT *, ST_Centroid(geom) AS stred_ziliny
FROM hranica_za;

--"Determine the total length of all segments (in kilometers) within the city of Žilina where the maximum speed limit is 70 km/h."

SELECT SUM(ST_Length(geom)) / 1000 AS dlzka_usekov_70kmh
FROM cesty 
WHERE maxspeed = 70; 

--"Determine the geometry type of the layer representing the boundaries of the city of Žilina (hranica_za)."

SELECT ST_GeometryType (geom) AS typ_geometrie, geom 
FROM hranica_za; 

--"Find out the type of reference coordinate system that the layer of the boundaries of the city of Žilina (hranica_za) has."

SELECT ST_srid(geom) AS typ_geometrie
FROM hranica_za;

--"Find the bounding box of the boundary layer of the city of Žilina (hranica_za)."

SELECT ST_envelope(geom) AS obalka, geom
FROM hranica_za; 

--"Create a new table named 'geoimp' from the 'geodeticke_firmy' table, selecting only the company GEOIMP - Ing. Marián Povoda."

CREATE TABLE geoimp AS
    SELECT * 
    FROM geodeticke_firmy 
    WHERE nazov_spol LIKE 'GEOIMP%';
    
--"Create a new table named 'ulica_uniza' from the 'cesty' table, selecting only the street with the name 'Univerzitná'."

CREATE TABLE ulica_uniza AS
    SELECT * 
    FROM cesty 
    WHERE name = 'Univerzitná';

--"Calculate the distances between the segments of the street 'Univerzitná' and the company 'GEOIMP - Ing. Marián Povoda'."
 
SELECT ST_Distance (geoimp.geom, ulica_uniza.geom), ulica_uniza.geom, geoimp.geom 
FROM geoimp, ulica_uniza; 

--"Create a buffer zone with a width of 4 meters (2 meters on each side) around all bike paths in Žilina. Save the buffer layer into a new table named 'ochranna_zona'."

CREATE TABLE ochranna_zona AS 
    SELECT ST_Buffer(geom,2) 
    FROM cesty 
    WHERE fclass = 'cycleway';

--"Merge all overlapping polygons within the buffer zone of bike paths to create seamless polygons. Create a new table named 'ochranna_zona_union'."

CREATE TABLE ochranna_zona_union AS
    SELECT ST_Union (ochranna_zona.st_buffer) 
    FROM ochranna_zona;

--"Select all road and railway segments that intersect with each other."

SELECT ST_crosses (cesty.geom, zel_trate.geom), cesty.geom, zel_trate.geom 
FROM cesty, zel_trate;

--"Determine if all geodetic firms in Žilina are located within the city limits of Žilina."

SELECT ST_within (geodeticke_firmy.geom,hranica_za.geom), hranica_za.geom, geodeticke_firmy.geom 
FROM hranica_za, geodeticke_firmy;
