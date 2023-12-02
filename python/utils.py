import serial
import time
import math

import numpy as np
import json
from sqlgpt import SQLGPT
from transformers import pipeline
from loguru import logger

transcriber = pipeline("automatic-speech-recognition", model="openai/whisper-base.en")


def send_to_arduino(stmt_res, cost):
    arduino_port = "/dev/cu.usbmodem11101"

    ser = serial.Serial(arduino_port, 9600, timeout=1)
    data = {"cost": cost, "result": stmt_res}
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
    # logger.success("TRANSRIBED TEXT ", s_to_txt)
    start = time.time()
    sql_stmt, sql_res = s.run_sql_stmt(s_to_txt)
    time_to_exec = time.time() - start
    # logger.success("TIME TO EXECUTE ", time_to_exec)
    pushups = cost(time_to_exec, len(sql_stmt), len(s_to_txt))
    # logger.success("SQL STMT ", sql_stmt)
    # logger.success("SQL STMT RES", sql_res)
    send_to_arduino(sql_res, pushups)
    logger.success(
        f"\n -> Transcribed Text - {s_to_txt} \n -> SQL Stmt - {sql_stmt} \n -> SQL Stmt Result - {sql_res}\n -> Cost - {pushups} pushups"
    )
    return s_to_txt, sql_stmt, sql_res, pushups


def cost(time_to_exec, len_of_sql, len_of_spoken):
    return min(math.ceil(3 * time_to_exec + ((len_of_sql + len_of_spoken) // 30)), 10)
