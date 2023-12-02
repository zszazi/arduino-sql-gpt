import json
import math
import os
import time

import gradio as gr
import numpy as np
import openai
import psycopg2
import serial
from loguru import logger
from transformers import pipeline

transcriber = pipeline("automatic-speech-recognition", model="openai/whisper-base.en")


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

from dotenv import load_dotenv

load_dotenv()


class SQLGPT:
    def __init__(self) -> None:
        pass

    def form_sql_stmt(self, user_prompt: str) -> str:
        form_prompt = PRE_PROMPT + user_prompt + USER_QUERY_SUFFIX

        openai.api_key = os.environ.get("OPENAI_GPT_KEY")
        response = openai.Completion.create(
            model="text-davinci-003",
            prompt=form_prompt,
            temperature=0,
            max_tokens=150,
            top_p=1.0,
            frequency_penalty=0.0,
            presence_penalty=0.0,
            stop=["#", ";"],
        )

        sql_response = "SELECT " + response["choices"][0]["text"]

        return sql_response

    def run_sql_stmt(self, sqlgpt_result: str = None) -> str:
        stmt_to_run = self.form_sql_stmt(sqlgpt_result)
        try:
            conn = psycopg2.connect(
                database=os.getenv("POSTGRES_DB"),
                user=os.getenv("POSTGRES_USER"),
                password=os.getenv("POSTGRES_PASSWORD"),
                host=os.getenv("POSTGRES_SERVER"),
                port=os.getenv("POSTGRES_PORT"),
            )
            cur = conn.cursor()
            cur.execute(stmt_to_run)
            rows = cur.fetchall()
            processed_result = self.process_sql_result(str(rows))
            return stmt_to_run, processed_result

        except Exception as e:
            logger.error(e)
            logger.error("Database not connected successfully")

    def process_sql_result(self, query_result: str) -> str:
        return "".join(e for e in query_result if e.isalnum())


def cost(time_to_exec, len_of_sql, len_of_spoken):
    return min(math.ceil(3 * time_to_exec + ((len_of_sql + len_of_spoken) // 30)), 10)


def send_to_arduino(stmt_res, cost):
    arduino_port = "/dev/cu.usbmodem11101"

    # Configure the serial port
    ser = serial.Serial(arduino_port, 9600, timeout=1)
    data = {"cost": 10, "result": stmt_res}
    json_data = json.dumps(data)
    time.sleep(2)
    ser.write(json_data.encode() + b"\n")
    ser.close()


def transcribe(audio):
    sr, y = audio
    y = y.astype(np.float32)
    y /= np.max(np.abs(y))
    s = SQLGPT()
    s_to_txt = transcriber({"sampling_rate": sr, "raw": y})["text"]
    print("TRANSRIBED TEXT ", s_to_txt)
    start = time.time()
    sql_stmt, sql_res = s.run_sql_stmt(s_to_txt)
    time_to_exec = time.time() - start
    print("TIME TO EXECUTE ", time_to_exec)
    pushups = cost(time_to_exec, len(sql_stmt), len(s_to_txt))
    print("SQL STMT ", sql_stmt)
    print("SQL STMT RES", sql_res)
    send_to_arduino(sql_res, pushups)
    print(s_to_txt, sql_stmt, sql_res, pushups, sep="\n *")
    return s_to_txt, sql_stmt, sql_res, pushups


demo = gr.Interface(
    transcribe, gr.Audio(sources=["microphone"]), ["text", "text", "text", "text"]
)

demo.launch()
