TABLE_PROP = """
## Instructions:
Your task is convert a question into a SQL query, given a Postgres database schema.
Adhere to these rules:
- **Deliberately go through the question and database schema word by word** to appropriately answer the question
- **Use Table Aliases** to prevent ambiguity. For example, `SELECT table1.col1, table2.col1 FROM table1 JOIN table2 ON table1.id = table2.id`.
- When creating a ratio, always cast the numerator as float

### Input:
Generate a SQL query that answers the question.
This query will run on a database whose schema is represented in this string:
CREATE TABLE IF NOT EXISTS buildings (
    building_id SERIAL PRIMARY KEY, -- unique ID for the building
    building_name VARCHAR(255) NOT NULL, -- the building name at UT austin , University of texas at Austin 
    total_floors INT, -- number of floors in each of the building
    has_lift BOOLEAN, -- if the building has lift
    num_lights INT, -- number of lights in each of the building
    num_fans INT, -- number of fans in each of the building
    num_doors INT, -- number of doors in each of the building 
    num_windows INT -- number of windows in each of the building 
);

-- Creating the 'electricity_consumption' table
CREATE TABLE IF NOT EXISTS electricity_consumption (
    consumption_id SERIAL PRIMARY KEY, - primary key of current table 
    building_id INT, -- links back to the building_id of the buildings table
    month DATE, -- month in the YYYY-MM-DD format
    consumption_kwh DECIMAL(10,2), -- consumption of the building in that month in kwh
    renewable_percentage DECIMAL(5,2), -- percentage of consumption of the building in that month generated from renewable resources
    FOREIGN KEY (building_id) REFERENCES buildings(building_id) -- foreign key reference between electricity_consumption table and buildings table
);
-- Creating the 'waste_mgmt' table
CREATE TABLE IF NOT EXISTS waste_mgmt (
    waste_id SERIAL PRIMARY KEY, -- primary key of the table
    building_id INT, -- links back to the building_id of the buildings table
    month DATE, -- month in the YYYY-MM-DD format
    total_waste_kg DECIMAL(10,2), -- total waste generated of the building in that month in kg
    recycled_waste_kg DECIMAL(10,2), -- total waste recycled of the building in that month in kg
    non_recyclable_waste_kg DECIMAL(10,2), -- total waste non recycled of the building in that month in kg, non_recyclable_waste_kg + recycled_waste_kg = total_waste_kg
    FOREIGN KEY (building_id) REFERENCES buildings(building_id)  -- foreign key reference between waste_mgmt table and buildings table
);
"""

USER_QUERY_PREFIX = "### A Query to "
USER_QUERY_SUFFIX = "\nSELECT "

PRE_PROMPT = TABLE_PROP + USER_QUERY_PREFIX
