## Instructions on how to setup the project 


### Database setup 

Tested on Postgres v15

Get inside the postgres prompt, create database and restore the sql file
```
CREATE DATABASE IF NOT EXISTS phyinfo;
psql prompt
\i <path to sql>
```

or use TablePlus or another other postgres Interface to import data in the sql file - data/data.sql after creating the database 

### Arduino Code

compile and upload to Arduino 33 Nano BLE

Libraries to include 
```
ArduinoBLE
ArduinoJson
U8g2lib
Adafruit_NeoPixel
avr/power
```

1. Central Code - arduino/central.ino
2. Peripheral - arduino/peripheral.ino

### Python Code

Tested on Python 3.11.5

1. create a virtual environment and install python dependencies
```
python -m venv .gptenv
source .gptenv/bin/activate
pip install -r python/requirements.txt
```

2. export env variables
```
export OPENAI_GPT_KEY="<your key>"
export POSTGRES_DB="phyinfo"
```
3. Start the gradio server ( from the python dir) 
```
python main.py
```


