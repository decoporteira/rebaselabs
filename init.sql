CREATE DATABASE development;
\c development;

CREATE TABLE IF NOT EXISTS patients (
  id SERIAL,
  cpf VARCHAR(14),
  nome_paciente VARCHAR(255),
  email_paciente VARCHAR(255),
  data_nascimento_paciente DATE,
  endereco_paciente VARCHAR(255),
  cidade_paciente VARCHAR(100),
  estado_paciente VARCHAR(50),
  PRIMARY KEY(id),
  UNIQUE (cpf)
);

CREATE TABLE IF NOT EXISTS doctors (
  id SERIAL,
  nome_medico VARCHAR(255),
  crm_medico VARCHAR(20) UNIQUE,
  crm_medico_estado VARCHAR(50),
  email_medico VARCHAR(255),
  PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS exams (
  id SERIAL,
  patient_id INTEGER,
  doctor_id INTEGER,
  token_resultado_exame VARCHAR(100) UNIQUE,
  data_exame DATE,
  PRIMARY KEY(id),
  FOREIGN KEY(patient_id) REFERENCES patients(id),
  FOREIGN KEY(doctor_id) REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS exam_types (
  id SERIAL,
  exam_id INTEGER,
  tipo_exame VARCHAR(100),
  limites_tipo_exame VARCHAR(255),
  resultado_tipo_exame VARCHAR(255),
  PRIMARY KEY(id),
  FOREIGN KEY(exam_id) REFERENCES exams(id)
  );

CREATE DATABASE test;
\c test;

CREATE TABLE IF NOT EXISTS patients (
  id SERIAL,
  cpf VARCHAR(14),
  nome_paciente VARCHAR(255),
  email_paciente VARCHAR(255),
  data_nascimento_paciente DATE,
  endereco_paciente VARCHAR(255),
  cidade_paciente VARCHAR(100),
  estado_paciente VARCHAR(50),
  PRIMARY KEY(id),
  UNIQUE (cpf)
);

CREATE TABLE IF NOT EXISTS doctors (
  id SERIAL,
  nome_medico VARCHAR(255),
  crm_medico VARCHAR(20) UNIQUE,
  crm_medico_estado VARCHAR(50),
  email_medico VARCHAR(255),
  PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS exams (
  id SERIAL,
  patient_id INTEGER,
  doctor_id INTEGER,
  token_resultado_exame VARCHAR(100) UNIQUE,
  data_exame DATE,
  PRIMARY KEY(id),
  FOREIGN KEY(patient_id) REFERENCES patients(id),
  FOREIGN KEY(doctor_id) REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS exam_types (
  id SERIAL,
  exam_id INTEGER,
  tipo_exame VARCHAR(100),
  limites_tipo_exame VARCHAR(255),
  resultado_tipo_exame VARCHAR(255),
  PRIMARY KEY(id),
  FOREIGN KEY(exam_id) REFERENCES exams(id)
  );