--
-- PostgreSQL database dump
--

\restrict PDdtskNKpWFPxAzgzTdEKZ4rOl4mJ3pKVj7MNy3f2D29Y5OCPopujPQcKQ71RoE

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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

--
-- Name: chat_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.chat_status_enum AS ENUM (
    'active',
    'closed'
);


ALTER TYPE public.chat_status_enum OWNER TO postgres;

--
-- Name: listing_interest_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.listing_interest_status_enum AS ENUM (
    'pending',
    'withdrawn',
    'accepted',
    'rejected'
);


ALTER TYPE public.listing_interest_status_enum OWNER TO postgres;

--
-- Name: listing_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.listing_status_enum AS ENUM (
    'draft',
    'published',
    'archived'
);


ALTER TYPE public.listing_status_enum OWNER TO postgres;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role_enum AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.user_role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id bigint NOT NULL,
    exchange_id bigint NOT NULL,
    status public.chat_status_enum DEFAULT 'active'::public.chat_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chats_id_seq OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;


--
-- Name: exchange_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchange_participants (
    exchange_id bigint NOT NULL,
    user_id bigint NOT NULL,
    gives_skill_id integer,
    gets_skill_id integer,
    "position" smallint NOT NULL
);


ALTER TABLE public.exchange_participants OWNER TO postgres;

--
-- Name: exchanges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchanges (
    id bigint NOT NULL,
    initiator_id bigint NOT NULL,
    status character varying NOT NULL,
    is_chain boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    is_deleted boolean NOT NULL,
    deleted_at timestamp with time zone,
    is_moderated boolean NOT NULL,
    moderated_by bigint,
    listing_id bigint,
    completed_by_initiator boolean DEFAULT false NOT NULL,
    completed_by_partner boolean DEFAULT false NOT NULL,
    started_by_initiator boolean DEFAULT false NOT NULL,
    started_by_partner boolean DEFAULT false NOT NULL,
    started_at timestamp with time zone
);


ALTER TABLE public.exchanges OWNER TO postgres;

--
-- Name: exchanges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exchanges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exchanges_id_seq OWNER TO postgres;

--
-- Name: exchanges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exchanges_id_seq OWNED BY public.exchanges.id;


--
-- Name: listing_interests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listing_interests (
    id bigint NOT NULL,
    listing_id bigint NOT NULL,
    responder_id bigint NOT NULL,
    message text,
    status public.listing_interest_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.listing_interests OWNER TO postgres;

--
-- Name: listing_interests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.listing_interests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.listing_interests_id_seq OWNER TO postgres;

--
-- Name: listing_interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.listing_interests_id_seq OWNED BY public.listing_interests.id;


--
-- Name: listings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listings (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    title character varying NOT NULL,
    description text,
    offering_summary text NOT NULL,
    seeking_summary text NOT NULL,
    status public.listing_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.listings OWNER TO postgres;

--
-- Name: listings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.listings_id_seq OWNER TO postgres;

--
-- Name: listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.listings_id_seq OWNED BY public.listings.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    task_id bigint,
    sender_id bigint NOT NULL,
    content text,
    media_url text,
    media_type text,
    media_size integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean NOT NULL,
    exchange_id bigint,
    chat_id bigint,
    edited_at timestamp with time zone,
    CONSTRAINT ck_message_context CHECK ((((chat_id IS NOT NULL) AND (task_id IS NULL)) OR ((task_id IS NOT NULL) AND (chat_id IS NULL))))
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    exchange_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    reviewed_id bigint NOT NULL,
    rating smallint NOT NULL,
    comment text,
    is_deleted boolean NOT NULL,
    deleted_at timestamp with time zone,
    is_moderated boolean NOT NULL,
    is_hidden boolean NOT NULL,
    moderated_by bigint,
    CONSTRAINT ck_review_rating_range CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: skill_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skill_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    parent_id integer,
    is_deleted boolean NOT NULL,
    deleted_at timestamp with time zone,
    is_moderated boolean NOT NULL,
    moderated_by bigint
);


ALTER TABLE public.skill_categories OWNER TO postgres;

--
-- Name: skill_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skill_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skill_categories_id_seq OWNER TO postgres;

--
-- Name: skill_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skill_categories_id_seq OWNED BY public.skill_categories.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name character varying NOT NULL,
    category_id integer NOT NULL,
    description text,
    is_deleted boolean NOT NULL,
    deleted_at timestamp with time zone,
    is_moderated boolean NOT NULL,
    moderated_by bigint
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_id_seq OWNER TO postgres;

--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    exchange_id bigint NOT NULL,
    assignee_id bigint NOT NULL,
    title character varying NOT NULL,
    status character varying NOT NULL
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: user_skills_offered; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_skills_offered (
    user_id bigint NOT NULL,
    skill_id integer NOT NULL,
    level smallint NOT NULL,
    description text
);


ALTER TABLE public.user_skills_offered OWNER TO postgres;

--
-- Name: user_skills_wanted; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_skills_wanted (
    user_id bigint NOT NULL,
    skill_id integer NOT NULL,
    desired_level smallint NOT NULL,
    priority smallint NOT NULL
);


ALTER TABLE public.user_skills_wanted OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    phone character varying(20),
    password_hash text NOT NULL,
    full_name character varying,
    avatar_url text,
    rating numeric(3,2) NOT NULL,
    role public.user_role_enum NOT NULL,
    is_deleted boolean NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_active_at timestamp with time zone,
    is_fraudulent boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);


--
-- Name: exchanges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchanges ALTER COLUMN id SET DEFAULT nextval('public.exchanges_id_seq'::regclass);


--
-- Name: listing_interests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_interests ALTER COLUMN id SET DEFAULT nextval('public.listing_interests_id_seq'::regclass);


--
-- Name: listings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings ALTER COLUMN id SET DEFAULT nextval('public.listings_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: skill_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill_categories ALTER COLUMN id SET DEFAULT nextval('public.skill_categories_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
20260529_make_skills_nullable
\.


--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chats (id, exchange_id, status, created_at) FROM stdin;
\.


--
-- Data for Name: exchange_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exchange_participants (exchange_id, user_id, gives_skill_id, gets_skill_id, "position") FROM stdin;
\.


--
-- Data for Name: exchanges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exchanges (id, initiator_id, status, is_chain, created_at, completed_at, is_deleted, deleted_at, is_moderated, moderated_by, listing_id, completed_by_initiator, completed_by_partner, started_by_initiator, started_by_partner, started_at) FROM stdin;
\.


--
-- Data for Name: listing_interests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.listing_interests (id, listing_id, responder_id, message, status, created_at) FROM stdin;
\.


--
-- Data for Name: listings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.listings (id, author_id, title, description, offering_summary, seeking_summary, status, created_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, task_id, sender_id, content, media_url, media_type, media_size, created_at, is_deleted, exchange_id, chat_id, edited_at) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, exchange_id, reviewer_id, reviewed_id, rating, comment, is_deleted, deleted_at, is_moderated, is_hidden, moderated_by) FROM stdin;
\.


--
-- Data for Name: skill_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skill_categories (id, name, parent_id, is_deleted, deleted_at, is_moderated, moderated_by) FROM stdin;
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skills (id, name, category_id, description, is_deleted, deleted_at, is_moderated, moderated_by) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, exchange_id, assignee_id, title, status) FROM stdin;
\.


--
-- Data for Name: user_skills_offered; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_skills_offered (user_id, skill_id, level, description) FROM stdin;
\.


--
-- Data for Name: user_skills_wanted; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_skills_wanted (user_id, skill_id, desired_level, priority) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, phone, password_hash, full_name, avatar_url, rating, role, is_deleted, deleted_at, created_at, last_active_at, is_fraudulent) FROM stdin;
\.


--
-- Name: chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chats_id_seq', 1, false);


--
-- Name: exchanges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exchanges_id_seq', 1, false);


--
-- Name: listing_interests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.listing_interests_id_seq', 1, false);


--
-- Name: listings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.listings_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: skill_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skill_categories_id_seq', 1, false);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_id_seq', 1, false);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: chats chats_exchange_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_exchange_id_key UNIQUE (exchange_id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: exchanges exchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT exchanges_pkey PRIMARY KEY (id);


--
-- Name: listing_interests listing_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_interests
    ADD CONSTRAINT listing_interests_pkey PRIMARY KEY (id);


--
-- Name: listings listings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: skill_categories skill_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: exchange_participants uq_exchange_participant; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_participants
    ADD CONSTRAINT uq_exchange_participant PRIMARY KEY (exchange_id, user_id);


--
-- Name: listing_interests uq_listing_interest_responder; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_interests
    ADD CONSTRAINT uq_listing_interest_responder UNIQUE (listing_id, responder_id);


--
-- Name: reviews uq_review_exchange_reviewer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT uq_review_exchange_reviewer UNIQUE (exchange_id, reviewer_id);


--
-- Name: user_skills_offered uq_user_skills_offered; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_offered
    ADD CONSTRAINT uq_user_skills_offered PRIMARY KEY (user_id, skill_id);


--
-- Name: user_skills_wanted uq_user_skills_wanted; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_wanted
    ADD CONSTRAINT uq_user_skills_wanted PRIMARY KEY (user_id, skill_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_chats_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_chats_exchange_id ON public.chats USING btree (exchange_id);


--
-- Name: ix_exchange_participants_gets_skill_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchange_participants_gets_skill_id ON public.exchange_participants USING btree (gets_skill_id);


--
-- Name: ix_exchange_participants_gives_skill_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchange_participants_gives_skill_id ON public.exchange_participants USING btree (gives_skill_id);


--
-- Name: ix_exchanges_initiator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchanges_initiator_id ON public.exchanges USING btree (initiator_id);


--
-- Name: ix_exchanges_listing_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchanges_listing_id ON public.exchanges USING btree (listing_id);


--
-- Name: ix_exchanges_moderated_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchanges_moderated_by ON public.exchanges USING btree (moderated_by);


--
-- Name: ix_listing_interests_listing_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_listing_interests_listing_id ON public.listing_interests USING btree (listing_id);


--
-- Name: ix_listing_interests_responder_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_listing_interests_responder_id ON public.listing_interests USING btree (responder_id);


--
-- Name: ix_listings_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_listings_author_id ON public.listings USING btree (author_id);


--
-- Name: ix_listings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_listings_status ON public.listings USING btree (status);


--
-- Name: ix_messages_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_chat_id ON public.messages USING btree (chat_id);


--
-- Name: ix_messages_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_exchange_id ON public.messages USING btree (exchange_id);


--
-- Name: ix_messages_sender_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_sender_id ON public.messages USING btree (sender_id);


--
-- Name: ix_messages_task_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_task_id ON public.messages USING btree (task_id);


--
-- Name: ix_reviews_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reviews_exchange_id ON public.reviews USING btree (exchange_id);


--
-- Name: ix_reviews_moderated_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reviews_moderated_by ON public.reviews USING btree (moderated_by);


--
-- Name: ix_reviews_reviewed_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reviews_reviewed_id ON public.reviews USING btree (reviewed_id);


--
-- Name: ix_reviews_reviewer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reviews_reviewer_id ON public.reviews USING btree (reviewer_id);


--
-- Name: ix_skill_categories_moderated_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_skill_categories_moderated_by ON public.skill_categories USING btree (moderated_by);


--
-- Name: ix_skill_categories_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_skill_categories_parent_id ON public.skill_categories USING btree (parent_id);


--
-- Name: ix_skills_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_skills_category_id ON public.skills USING btree (category_id);


--
-- Name: ix_skills_moderated_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_skills_moderated_by ON public.skills USING btree (moderated_by);


--
-- Name: ix_skills_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_skills_name ON public.skills USING btree (name);


--
-- Name: ix_tasks_assignee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tasks_assignee_id ON public.tasks USING btree (assignee_id);


--
-- Name: ix_tasks_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tasks_exchange_id ON public.tasks USING btree (exchange_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: chats chats_exchange_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_exchange_id_fkey FOREIGN KEY (exchange_id) REFERENCES public.exchanges(id) ON DELETE CASCADE;


--
-- Name: exchange_participants exchange_participants_exchange_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_participants
    ADD CONSTRAINT exchange_participants_exchange_id_fkey FOREIGN KEY (exchange_id) REFERENCES public.exchanges(id) ON DELETE CASCADE;


--
-- Name: exchange_participants exchange_participants_gets_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_participants
    ADD CONSTRAINT exchange_participants_gets_skill_id_fkey FOREIGN KEY (gets_skill_id) REFERENCES public.skills(id) ON DELETE RESTRICT;


--
-- Name: exchange_participants exchange_participants_gives_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_participants
    ADD CONSTRAINT exchange_participants_gives_skill_id_fkey FOREIGN KEY (gives_skill_id) REFERENCES public.skills(id) ON DELETE RESTRICT;


--
-- Name: exchange_participants exchange_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_participants
    ADD CONSTRAINT exchange_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: exchanges exchanges_initiator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT exchanges_initiator_id_fkey FOREIGN KEY (initiator_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: exchanges exchanges_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT exchanges_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: exchanges fk_exchanges_listing_id_listings; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchanges
    ADD CONSTRAINT fk_exchanges_listing_id_listings FOREIGN KEY (listing_id) REFERENCES public.listings(id) ON DELETE SET NULL;


--
-- Name: messages fk_messages_exchange_id_exchanges; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_messages_exchange_id_exchanges FOREIGN KEY (exchange_id) REFERENCES public.exchanges(id) ON DELETE CASCADE;


--
-- Name: listing_interests listing_interests_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_interests
    ADD CONSTRAINT listing_interests_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(id) ON DELETE CASCADE;


--
-- Name: listing_interests listing_interests_responder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_interests
    ADD CONSTRAINT listing_interests_responder_id_fkey FOREIGN KEY (responder_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: listings listings_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: messages messages_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: reviews reviews_exchange_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_exchange_id_fkey FOREIGN KEY (exchange_id) REFERENCES public.exchanges(id) ON DELETE CASCADE;


--
-- Name: reviews reviews_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reviews reviews_reviewed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_reviewed_id_fkey FOREIGN KEY (reviewed_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: reviews reviews_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: skill_categories skill_categories_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: skill_categories skill_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.skill_categories(id) ON DELETE SET NULL;


--
-- Name: skills skills_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.skill_categories(id) ON DELETE RESTRICT;


--
-- Name: skills skills_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: tasks tasks_exchange_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_exchange_id_fkey FOREIGN KEY (exchange_id) REFERENCES public.exchanges(id) ON DELETE CASCADE;


--
-- Name: user_skills_offered user_skills_offered_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_offered
    ADD CONSTRAINT user_skills_offered_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: user_skills_offered user_skills_offered_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_offered
    ADD CONSTRAINT user_skills_offered_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_skills_wanted user_skills_wanted_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_wanted
    ADD CONSTRAINT user_skills_wanted_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: user_skills_wanted user_skills_wanted_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_skills_wanted
    ADD CONSTRAINT user_skills_wanted_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict PDdtskNKpWFPxAzgzTdEKZ4rOl4mJ3pKVj7MNy3f2D29Y5OCPopujPQcKQ71RoE

