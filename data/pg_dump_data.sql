--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: buildings; Type: TABLE; Schema: public; Owner: sai
--

CREATE TABLE public.buildings (
    building_id integer NOT NULL,
    building_name character varying(255) NOT NULL,
    total_floors integer,
    has_lift boolean,
    num_lights integer,
    num_fans integer,
    num_doors integer,
    num_windows integer
);


ALTER TABLE public.buildings OWNER TO sai;

--
-- Name: buildings_building_id_seq; Type: SEQUENCE; Schema: public; Owner: sai
--

CREATE SEQUENCE public.buildings_building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.buildings_building_id_seq OWNER TO sai;

--
-- Name: buildings_building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sai
--

ALTER SEQUENCE public.buildings_building_id_seq OWNED BY public.buildings.building_id;


--
-- Name: electricity_consumption; Type: TABLE; Schema: public; Owner: sai
--

CREATE TABLE public.electricity_consumption (
    consumption_id integer NOT NULL,
    building_id integer,
    month date,
    consumption_kwh numeric(10,2),
    renewable_percentage numeric(5,2)
);


ALTER TABLE public.electricity_consumption OWNER TO sai;

--
-- Name: electricity_consumption_consumption_id_seq; Type: SEQUENCE; Schema: public; Owner: sai
--

CREATE SEQUENCE public.electricity_consumption_consumption_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.electricity_consumption_consumption_id_seq OWNER TO sai;

--
-- Name: electricity_consumption_consumption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sai
--

ALTER SEQUENCE public.electricity_consumption_consumption_id_seq OWNED BY public.electricity_consumption.consumption_id;


--
-- Name: waste_mgmt; Type: TABLE; Schema: public; Owner: sai
--

CREATE TABLE public.waste_mgmt (
    waste_id integer NOT NULL,
    building_id integer,
    month date,
    total_waste_kg numeric(10,2),
    recycled_waste_kg numeric(10,2),
    non_recyclable_waste_kg numeric(10,2)
);


ALTER TABLE public.waste_mgmt OWNER TO sai;

--
-- Name: waste_mgmt_waste_id_seq; Type: SEQUENCE; Schema: public; Owner: sai
--

CREATE SEQUENCE public.waste_mgmt_waste_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.waste_mgmt_waste_id_seq OWNER TO sai;

--
-- Name: waste_mgmt_waste_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sai
--

ALTER SEQUENCE public.waste_mgmt_waste_id_seq OWNED BY public.waste_mgmt.waste_id;


--
-- Name: buildings building_id; Type: DEFAULT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.buildings ALTER COLUMN building_id SET DEFAULT nextval('public.buildings_building_id_seq'::regclass);


--
-- Name: electricity_consumption consumption_id; Type: DEFAULT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.electricity_consumption ALTER COLUMN consumption_id SET DEFAULT nextval('public.electricity_consumption_consumption_id_seq'::regclass);


--
-- Name: waste_mgmt waste_id; Type: DEFAULT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.waste_mgmt ALTER COLUMN waste_id SET DEFAULT nextval('public.waste_mgmt_waste_id_seq'::regclass);


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: sai
--

COPY public.buildings (building_id, building_name, total_floors, has_lift, num_lights, num_fans, num_doors, num_windows) FROM stdin;
1	main building	5	t	100	20	30	80
2	science center	4	t	80	15	25	60
3	library	6	f	120	25	35	90
4	engineering building	7	t	150	30	40	100
5	arts hall	3	f	70	12	20	50
6	business school	6	t	110	22	32	75
7	medical center	8	t	180	35	45	120
8	student union	2	f	50	10	15	40
9	sports complex	3	t	60	15	22	55
10	dormitory a	5	f	90	18	28	70
\.


--
-- Data for Name: electricity_consumption; Type: TABLE DATA; Schema: public; Owner: sai
--

COPY public.electricity_consumption (consumption_id, building_id, month, consumption_kwh, renewable_percentage) FROM stdin;
101	1	2023-01-01	5000.25	20.50
102	1	2023-02-01	4800.30	18.70
103	1	2023-03-01	5200.45	21.20
104	1	2023-04-01	5500.60	23.00
105	1	2023-05-01	5300.75	22.50
106	1	2023-06-01	5100.90	20.80
107	1	2023-07-01	4900.45	19.50
108	1	2023-08-01	4700.60	18.20
109	1	2023-09-01	5400.75	22.80
110	1	2023-10-01	5200.90	21.50
111	2	2023-01-01	4200.75	15.30
112	2	2023-02-01	4000.60	14.50
113	2	2023-03-01	4300.45	16.20
114	2	2023-04-01	4500.30	17.80
115	2	2023-05-01	4100.15	15.00
116	2	2023-06-01	3900.90	14.20
117	2	2023-07-01	3700.75	13.50
118	2	2023-08-01	4400.60	16.80
119	2	2023-09-01	4200.45	15.50
120	2	2023-10-01	4000.30	14.80
121	3	2023-01-01	6000.50	10.20
122	3	2023-02-01	5800.35	9.50
123	3	2023-03-01	5600.20	8.80
124	3	2023-04-01	5400.05	8.10
125	3	2023-05-01	5200.90	7.40
126	3	2023-06-01	5000.75	6.70
127	3	2023-07-01	4800.60	6.00
128	3	2023-08-01	5600.45	7.70
129	3	2023-09-01	5400.30	7.00
130	3	2023-10-01	5200.15	6.30
131	4	2023-01-01	7500.80	25.80
132	4	2023-02-01	7300.65	25.10
133	4	2023-03-01	7100.50	24.40
134	4	2023-04-01	6900.35	23.70
135	4	2023-05-01	6700.20	23.00
136	4	2023-06-01	6500.05	22.30
137	4	2023-07-01	6300.90	21.60
138	4	2023-08-01	7100.75	23.30
139	4	2023-09-01	6900.60	22.60
140	4	2023-10-01	6700.45	21.90
141	5	2023-01-01	3500.40	5.50
142	5	2023-02-01	3300.25	4.80
143	5	2023-03-01	3100.10	4.10
144	5	2023-04-01	2900.95	3.40
145	5	2023-05-01	2700.80	2.70
146	5	2023-06-01	2500.65	2.00
147	5	2023-07-01	3300.50	4.70
148	5	2023-08-01	3100.35	4.00
149	5	2023-09-01	2900.20	3.30
150	5	2023-10-01	2700.05	2.60
151	6	2023-01-01	4800.60	18.70
152	6	2023-02-01	4600.45	18.00
153	6	2023-03-01	4400.30	17.30
154	6	2023-04-01	4200.15	16.60
155	6	2023-05-01	4000.90	15.90
156	6	2023-06-01	3800.75	15.20
157	6	2023-07-01	3600.60	14.50
158	6	2023-08-01	4400.45	16.20
159	6	2023-09-01	4200.30	15.50
160	6	2023-10-01	4000.15	14.80
161	7	2023-01-01	9000.90	30.40
162	7	2023-02-01	8800.75	29.70
163	7	2023-03-01	8600.60	29.00
164	7	2023-04-01	8400.45	28.30
165	7	2023-05-01	8200.30	27.60
166	7	2023-06-01	8000.15	26.90
167	7	2023-07-01	7800.90	26.20
168	7	2023-08-01	8600.75	27.90
169	7	2023-09-01	8400.60	27.20
170	7	2023-10-01	8200.45	26.50
171	8	2023-01-01	3000.30	8.90
172	8	2023-02-01	2800.15	8.20
173	8	2023-03-01	2600.00	7.50
174	8	2023-04-01	2400.85	6.80
175	8	2023-05-01	2200.70	6.10
176	8	2023-06-01	2000.55	5.40
177	8	2023-07-01	2800.40	7.10
178	8	2023-08-01	2600.25	6.40
179	8	2023-09-01	2400.10	5.70
180	8	2023-10-01	2200.95	5.00
181	9	2023-01-01	3800.45	12.60
182	9	2023-02-01	3600.30	11.90
183	9	2023-03-01	3400.15	11.20
184	9	2023-04-01	3200.00	10.50
185	9	2023-05-01	3000.85	9.80
186	9	2023-06-01	2800.70	9.10
187	9	2023-07-01	3600.55	11.80
188	9	2023-08-01	3400.40	11.10
189	9	2023-09-01	3200.25	10.40
190	9	2023-10-01	3000.10	9.70
191	10	2023-01-01	5500.70	22.00
192	10	2023-02-01	5300.55	21.30
193	10	2023-03-01	5100.40	20.60
194	10	2023-04-01	4900.25	19.90
195	10	2023-05-01	4700.10	19.20
196	10	2023-06-01	5500.95	22.30
197	10	2023-07-01	5300.80	21.60
198	10	2023-08-01	5100.65	20.90
199	10	2023-09-01	4900.50	20.20
200	10	2023-10-01	4700.35	19.50
\.


--
-- Data for Name: waste_mgmt; Type: TABLE DATA; Schema: public; Owner: sai
--

COPY public.waste_mgmt (waste_id, building_id, month, total_waste_kg, recycled_waste_kg, non_recyclable_waste_kg) FROM stdin;
101	1	2023-01-01	1200.25	400.75	799.50
102	1	2023-02-01	1100.30	350.60	749.70
103	1	2023-03-01	1300.45	450.30	849.15
104	1	2023-04-01	1400.60	500.15	899.45
105	1	2023-05-01	1200.75	400.90	799.85
106	1	2023-06-01	1000.90	350.75	649.15
107	1	2023-07-01	800.45	250.30	549.15
108	1	2023-08-01	1100.60	400.45	699.15
109	1	2023-09-01	1300.75	450.60	849.15
110	1	2023-10-01	1200.90	400.75	799.15
111	2	2023-01-01	900.50	300.20	599.30
112	2	2023-02-01	800.60	250.45	549.15
113	2	2023-03-01	1000.45	350.60	649.85
114	2	2023-04-01	1100.30	400.75	699.15
115	2	2023-05-01	900.15	300.90	599.25
116	2	2023-06-01	700.90	200.75	499.15
117	2	2023-07-01	500.75	150.45	349.15
118	2	2023-08-01	800.60	250.60	549.15
119	2	2023-09-01	1000.45	350.75	649.15
120	2	2023-10-01	900.30	300.90	599.15
121	3	2023-01-01	1500.80	500.40	1000.40
122	3	2023-02-01	1400.65	450.25	950.40
123	3	2023-03-01	1300.50	400.10	900.40
124	3	2023-04-01	1200.35	350.95	850.40
125	3	2023-05-01	1100.20	300.80	800.40
126	3	2023-06-01	1000.05	250.65	750.40
127	3	2023-07-01	900.90	200.50	700.40
128	3	2023-08-01	1000.75	250.35	750.40
129	3	2023-09-01	1100.60	300.20	800.40
130	3	2023-10-01	1200.45	350.95	850.40
131	4	2023-01-01	1800.90	600.30	1200.60
132	4	2023-02-01	1700.75	550.15	1150.60
133	4	2023-03-01	1600.60	500.00	1100.60
134	4	2023-04-01	1500.45	450.85	1050.60
135	4	2023-05-01	1400.30	400.70	1000.60
136	4	2023-06-01	1300.15	350.55	950.60
137	4	2023-07-01	1200.00	300.40	900.60
138	4	2023-08-01	1300.85	350.25	950.60
139	4	2023-09-01	1400.70	400.10	1000.60
140	4	2023-10-01	1500.55	450.95	1050.60
141	5	2023-01-01	750.40	250.15	500.25
142	5	2023-02-01	650.25	150.00	500.25
143	5	2023-03-01	550.10	50.85	500.25
144	5	2023-04-01	450.95	50.70	400.25
145	5	2023-05-01	350.80	50.55	300.25
146	5	2023-06-01	250.65	50.40	200.25
147	5	2023-07-01	350.50	50.25	300.25
148	5	2023-08-01	450.35	50.10	400.25
149	5	2023-09-01	550.20	49.95	500.25
150	5	2023-10-01	650.05	49.80	600.25
151	6	2023-01-01	1300.60	400.45	900.15
152	6	2023-02-01	1200.45	350.30	850.15
153	6	2023-03-01	1100.30	300.15	800.15
154	6	2023-04-01	1000.15	250.00	750.15
155	6	2023-05-01	900.00	200.85	700.15
156	6	2023-06-01	800.85	150.70	650.15
157	6	2023-07-01	700.70	100.55	600.15
158	6	2023-08-01	800.55	150.40	650.15
159	6	2023-09-01	900.40	200.25	700.15
160	6	2023-10-01	1000.25	250.10	750.15
161	7	2023-01-01	2200.90	700.35	1500.55
162	7	2023-02-01	2100.75	650.20	1450.55
163	7	2023-03-01	2000.60	600.05	1400.55
164	7	2023-04-01	1900.45	550.90	1350.55
165	7	2023-05-01	1800.30	500.75	1300.55
166	7	2023-06-01	1700.15	450.60	1250.55
167	7	2023-07-01	1600.00	400.45	1200.55
168	7	2023-08-01	1700.85	450.30	1250.55
169	7	2023-09-01	1800.70	500.15	1300.55
170	7	2023-10-01	1900.55	550.00	1350.55
171	8	2023-01-01	1000.30	250.15	750.15
172	8	2023-02-01	900.15	200.00	700.15
173	8	2023-03-01	800.00	150.85	650.15
174	8	2023-04-01	700.85	100.70	600.15
175	8	2023-05-01	600.70	50.55	550.15
176	8	2023-06-01	500.55	50.40	450.15
177	8	2023-07-01	600.40	50.25	550.15
178	8	2023-08-01	700.25	50.10	650.15
179	8	2023-09-01	800.10	49.95	750.15
180	8	2023-10-01	900.95	49.80	850.15
181	9	2023-01-01	1400.45	450.20	950.25
182	9	2023-02-01	1300.30	400.05	900.25
183	9	2023-03-01	1200.15	350.90	850.25
184	9	2023-04-01	1100.00	300.75	800.25
185	9	2023-05-01	1000.85	250.60	750.25
186	9	2023-06-01	900.70	200.45	700.25
187	9	2023-07-01	1000.55	250.30	750.25
188	9	2023-08-01	1100.40	300.15	800.25
189	9	2023-09-01	1200.25	350.00	850.25
190	9	2023-10-01	1300.10	400.85	900.25
191	10	2023-01-01	1800.70	550.35	1250.35
192	10	2023-02-01	1700.55	500.20	1200.35
193	10	2023-03-01	1600.40	450.05	1150.35
194	10	2023-04-01	1500.25	400.90	1100.35
195	10	2023-05-01	1400.10	350.75	1050.35
196	10	2023-06-01	1300.95	300.60	1000.35
197	10	2023-07-01	1200.80	250.45	950.35
198	10	2023-08-01	1300.65	300.30	1000.35
199	10	2023-09-01	1400.50	350.15	1050.35
200	10	2023-10-01	1500.35	400.00	1100.35
\.


--
-- Name: buildings_building_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sai
--

SELECT pg_catalog.setval('public.buildings_building_id_seq', 1, false);


--
-- Name: electricity_consumption_consumption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sai
--

SELECT pg_catalog.setval('public.electricity_consumption_consumption_id_seq', 200, true);


--
-- Name: waste_mgmt_waste_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sai
--

SELECT pg_catalog.setval('public.waste_mgmt_waste_id_seq', 200, true);


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (building_id);


--
-- Name: electricity_consumption electricity_consumption_pkey; Type: CONSTRAINT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.electricity_consumption
    ADD CONSTRAINT electricity_consumption_pkey PRIMARY KEY (consumption_id);


--
-- Name: waste_mgmt waste_mgmt_pkey; Type: CONSTRAINT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.waste_mgmt
    ADD CONSTRAINT waste_mgmt_pkey PRIMARY KEY (waste_id);


--
-- Name: electricity_consumption electricity_consumption_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.electricity_consumption
    ADD CONSTRAINT electricity_consumption_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(building_id);


--
-- Name: waste_mgmt waste_mgmt_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sai
--

ALTER TABLE ONLY public.waste_mgmt
    ADD CONSTRAINT waste_mgmt_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(building_id);


--
-- PostgreSQL database dump complete
--

