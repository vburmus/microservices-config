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

CREATE DATABASE commerce
/c commerce
CREATE TABLE public.certificate (
    id bigint NOT NULL,
    name character varying(15) NOT NULL,
    short_description character varying(50),
    long_description character varying(600),
    price numeric NOT NULL,
    image_url character varying(255) NOT NULL,
    duration_date timestamp(6) without time zone NOT NULL,
    create_date timestamp(6) without time zone NOT NULL,
    last_update_date timestamp(6) without time zone NOT NULL
);

CREATE TABLE public.certificate_tags (
    certificate_id bigint NOT NULL,
    tag_id bigint NOT NULL
);

CREATE SEQUENCE public.gift_certificate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE public.purchase (
    id integer NOT NULL,
    description character varying(255),
    cost numeric NOT NULL,
    create_date timestamp without time zone NOT NULL,
    last_update_date timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);

CREATE TABLE public.purchase_certificates (
    purchase_id bigint NOT NULL,
    certificate_id bigint NOT NULL,
    quantity integer NOT NULL
);

CREATE TABLE public.tag (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    image_url character varying(255) NOT NULL
);

CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE public.transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY public.certificate ALTER COLUMN id SET DEFAULT nextval('public.gift_certificate_id_seq'::regclass);

ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);

ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);

ALTER TABLE ONLY public.certificate_tags
    ADD CONSTRAINT certificate_tags_pkey PRIMARY KEY (certificate_id, tag_id);

ALTER TABLE ONLY public.certificate
    ADD CONSTRAINT gift_certificate_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.purchase_certificates
    ADD CONSTRAINT purchase_certificates_pkey PRIMARY KEY (purchase_id, certificate_id);

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);

CREATE INDEX fki_certificate_tags_tag_id_fkey ON public.certificate_tags USING btree (tag_id);

CREATE INDEX fki_certificates_tags_certificate_id_fkey ON public.certificate_tags USING btree (certificate_id);

ALTER TABLE ONLY public.certificate_tags
    ADD CONSTRAINT certificate_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.certificate_tags
    ADD CONSTRAINT certificates_tags_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES public.certificate(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.purchase_certificates
    ADD CONSTRAINT purchase_certificates_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES public.certificate(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.purchase_certificates
    ADD CONSTRAINT purchase_certificates_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.purchase(id) ON UPDATE CASCADE ON DELETE CASCADE;