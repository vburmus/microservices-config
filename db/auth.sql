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

CREATE DATABASE auth;

\c auth;

CREATE TYPE public.provider_enum AS ENUM (
    'LOCAL',
    'GOOGLE'
);
CREATE TYPE public.role_enum AS ENUM (
    'ADMIN',
    'USER'
);
CREATE TABLE public.credentials (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying NOT NULL,
    provider public.provider_enum NOT NULL,
    role public.role_enum NOT NULL,
    is_enabled boolean DEFAULT false NOT NULL
);
CREATE SEQUENCE public.credentials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY public.credentials ALTER COLUMN id SET DEFAULT nextval('public.credentials_id_seq'::regclass);

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);