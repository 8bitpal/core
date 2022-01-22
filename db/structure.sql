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
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    customer_id bigint,
    balance_cents integer DEFAULT 0 NOT NULL,
    currency character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    default_payment_method character varying
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    action text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    customer_id bigint,
    address_1 character varying,
    address_2 character varying,
    suburb character varying,
    city character varying,
    postcode character varying,
    delivery_note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    mobile_phone character varying,
    home_phone character varying,
    work_phone character varying,
    address_hash character varying
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bank_information; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_information (
    id bigint NOT NULL,
    distributor_id bigint,
    name character varying,
    account_name character varying,
    account_number character varying,
    customer_message text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cod_payment_message text
);


--
-- Name: bank_information_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_information_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_information_id_seq OWNED BY public.bank_information.id;


--
-- Name: box_extras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.box_extras (
    id bigint NOT NULL,
    box_id integer,
    extra_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: box_extras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.box_extras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: box_extras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.box_extras_id_seq OWNED BY public.box_extras.id;


--
-- Name: boxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boxes (
    id bigint NOT NULL,
    distributor_id bigint,
    name character varying,
    description text,
    likes boolean DEFAULT false NOT NULL,
    dislikes boolean DEFAULT false NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    available_single boolean DEFAULT false NOT NULL,
    available_weekly boolean DEFAULT false NOT NULL,
    available_fourtnightly boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    box_image character varying,
    available_monthly boolean DEFAULT false NOT NULL,
    extras_limit integer DEFAULT 0,
    hidden boolean DEFAULT false NOT NULL,
    exclusions_limit integer DEFAULT 0,
    substitutions_limit integer DEFAULT 0
);


--
-- Name: boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boxes_id_seq OWNED BY public.boxes.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    default_consumer_fee_cents integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    alpha2 character varying(2) DEFAULT ''::character varying NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: cron_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cron_logs (
    id bigint NOT NULL,
    log text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    details text
);


--
-- Name: cron_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cron_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cron_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cron_logs_id_seq OWNED BY public.cron_logs.id;


--
-- Name: customer_checkouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_checkouts (
    id bigint NOT NULL,
    distributor_id integer,
    customer_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: customer_checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_checkouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_checkouts_id_seq OWNED BY public.customer_checkouts.id;


--
-- Name: customer_logins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_logins (
    id bigint NOT NULL,
    distributor_id integer,
    customer_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: customer_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_logins_id_seq OWNED BY public.customer_logins.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name character varying,
    email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    last_name character varying,
    distributor_id integer,
    delivery_service_id integer,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    password_salt character varying,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying,
    locked_at timestamp(6) without time zone,
    authentication_token character varying,
    discount numeric DEFAULT 0.0 NOT NULL,
    number integer,
    notes text,
    special_order_preference text,
    next_order_id integer,
    next_order_occurrence_date date,
    balance_threshold_cents integer,
    status_halted boolean DEFAULT false,
    via_webstore boolean DEFAULT false
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: deductions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deductions (
    id bigint NOT NULL,
    distributor_id bigint,
    account_id bigint DEFAULT 0 NOT NULL,
    amount_cents integer DEFAULT 0 NOT NULL,
    kind character varying,
    description text,
    reversed boolean,
    reversed_at timestamp(6) without time zone,
    transaction_id integer,
    reversal_transaction_id integer,
    source character varying,
    deductable_id integer,
    deductable_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    display_time timestamp(6) without time zone
);


--
-- Name: deductions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deductions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deductions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deductions_id_seq OWNED BY public.deductions.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id bigint NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp(6) without time zone,
    locked_at timestamp(6) without time zone,
    failed_at timestamp(6) without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deliveries (
    id bigint NOT NULL,
    order_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status character varying,
    delivery_service_id integer,
    status_change_type character varying,
    delivery_list_id integer,
    "position" integer,
    package_id integer,
    delivery_number integer,
    dso integer DEFAULT '-1'::integer
);


--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;


--
-- Name: delivery_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_lists (
    id bigint NOT NULL,
    distributor_id bigint,
    date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: delivery_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_lists_id_seq OWNED BY public.delivery_lists.id;


--
-- Name: delivery_sequence_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_sequence_orders (
    id bigint NOT NULL,
    address_hash character varying,
    delivery_service_id integer,
    day integer,
    "position" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: delivery_sequence_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_sequence_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_sequence_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_sequence_orders_id_seq OWNED BY public.delivery_sequence_orders.id;


--
-- Name: delivery_service_schedule_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_service_schedule_transactions (
    id bigint NOT NULL,
    delivery_service_id bigint,
    schedule text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: delivery_service_schedule_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_service_schedule_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_service_schedule_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_service_schedule_transactions_id_seq OWNED BY public.delivery_service_schedule_transactions.id;


--
-- Name: delivery_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_services (
    id bigint NOT NULL,
    distributor_id bigint,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    fee_cents integer DEFAULT 0 NOT NULL,
    pickup_point boolean DEFAULT false NOT NULL,
    instructions text
);


--
-- Name: delivery_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_services_id_seq OWNED BY public.delivery_services.id;


--
-- Name: distributor_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributor_invoices (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    "from" date NOT NULL,
    "to" date NOT NULL,
    description text NOT NULL,
    amount_cents integer NOT NULL,
    currency character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    number character varying,
    paid boolean DEFAULT false NOT NULL
);


--
-- Name: distributor_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributor_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_invoices_id_seq OWNED BY public.distributor_invoices.id;


--
-- Name: distributor_logins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributor_logins (
    id bigint NOT NULL,
    distributor_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: distributor_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributor_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_logins_id_seq OWNED BY public.distributor_logins.id;


--
-- Name: distributor_pricings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributor_pricings (
    id bigint NOT NULL,
    distributor_id bigint,
    name character varying NOT NULL,
    flat_fee_cents integer DEFAULT 0 NOT NULL,
    percentage_fee numeric DEFAULT 0.0 NOT NULL,
    percentage_fee_max_cents integer DEFAULT 0 NOT NULL,
    discount_percentage numeric DEFAULT 0.0 NOT NULL,
    currency character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    invoicing_day_of_the_month integer DEFAULT 1 NOT NULL
);


--
-- Name: distributor_pricings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_pricings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributor_pricings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_pricings_id_seq OWNED BY public.distributor_pricings.id;


--
-- Name: distributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributors (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    password_salt character varying,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying,
    locked_at timestamp(6) without time zone,
    authentication_token character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying,
    url character varying,
    company_logo character varying,
    completed_wizard boolean DEFAULT false NOT NULL,
    parameter_name character varying,
    separate_bucky_fee boolean DEFAULT false,
    time_zone character varying,
    support_email character varying,
    advance_hour integer,
    advance_days integer,
    currency character varying,
    country_id integer,
    consumer_delivery_fee_cents integer,
    active_webstore boolean DEFAULT false NOT NULL,
    city character varying,
    company_team_image character varying,
    about text,
    details text,
    facebook_url character varying,
    customers_show_intro boolean DEFAULT true NOT NULL,
    deliveries_index_packing_intro boolean DEFAULT true NOT NULL,
    deliveries_index_deliveries_intro boolean DEFAULT true NOT NULL,
    payments_index_intro boolean DEFAULT true NOT NULL,
    customers_index_intro boolean DEFAULT true NOT NULL,
    customer_can_remove_orders boolean DEFAULT true,
    has_balance_threshold boolean DEFAULT false,
    default_balance_threshold_cents integer DEFAULT 0,
    send_email boolean DEFAULT true,
    send_halted_email boolean,
    feature_spend_limit boolean DEFAULT true,
    contact_name character varying,
    collect_phone boolean DEFAULT true NOT NULL,
    last_seen_at timestamp without time zone,
    notes text,
    payment_cash_on_delivery boolean DEFAULT true,
    payment_bank_deposit boolean DEFAULT true,
    payment_credit_card boolean DEFAULT false,
    require_postcode boolean DEFAULT false NOT NULL,
    keep_me_updated boolean DEFAULT true,
    require_phone boolean DEFAULT true NOT NULL,
    require_address_1 boolean DEFAULT true NOT NULL,
    require_address_2 boolean DEFAULT false NOT NULL,
    require_suburb boolean DEFAULT false NOT NULL,
    require_city boolean DEFAULT false NOT NULL,
    email_templates text,
    phone character varying,
    notify_address_change boolean,
    sidebar_description text,
    collect_delivery_note boolean DEFAULT true NOT NULL,
    require_delivery_note boolean DEFAULT false NOT NULL,
    notify_for_new_webstore_order boolean DEFAULT true NOT NULL,
    api_key character varying,
    api_secret character varying,
    email_customer_on_new_webstore_order boolean DEFAULT true NOT NULL,
    email_customer_on_new_order boolean DEFAULT false NOT NULL,
    email_distributor_on_new_webstore_order boolean DEFAULT false NOT NULL,
    customer_can_edit_orders boolean DEFAULT true NOT NULL,
    payment_paypal boolean DEFAULT false NOT NULL,
    paypal_email character varying,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    overdue text DEFAULT ''::text NOT NULL,
    ga_tracking_id character varying,
    status character varying DEFAULT 'trial'::character varying NOT NULL,
    intercom_id character varying,
    addons character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: distributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributors_id_seq OWNED BY public.distributors.id;


--
-- Name: distributors_omni_importers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributors_omni_importers (
    id bigint NOT NULL,
    distributor_id integer,
    omni_importer_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: distributors_omni_importers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributors_omni_importers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distributors_omni_importers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributors_omni_importers_id_seq OWNED BY public.distributors_omni_importers.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    event_type character varying NOT NULL,
    dismissed boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    trigger_on timestamp(6) without time zone,
    message text,
    key character varying
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exclusions (
    id bigint NOT NULL,
    order_id bigint,
    line_item_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: exclusions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exclusions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exclusions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exclusions_id_seq OWNED BY public.exclusions.id;


--
-- Name: extras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extras (
    id bigint NOT NULL,
    name character varying,
    unit character varying,
    distributor_id integer,
    price_cents integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hidden boolean DEFAULT false
);


--
-- Name: extras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.extras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: extras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.extras_id_seq OWNED BY public.extras.id;


--
-- Name: import_transaction_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_transaction_lists (
    id bigint NOT NULL,
    distributor_id integer,
    draft boolean,
    account_type integer,
    csv_file text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    omni_importer_id integer,
    status character varying
);


--
-- Name: import_transaction_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_transaction_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_transaction_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_transaction_lists_id_seq OWNED BY public.import_transaction_lists.id;


--
-- Name: import_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_transactions (
    id bigint NOT NULL,
    customer_id integer,
    transaction_date date,
    amount_cents integer DEFAULT 0 NOT NULL,
    removed boolean,
    description text,
    confidence double precision,
    import_transaction_list_id integer,
    match integer,
    transaction_id integer,
    draft boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    payment_id integer,
    raw_data text
);


--
-- Name: import_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_transactions_id_seq OWNED BY public.import_transactions.id;


--
-- Name: line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_items (
    id bigint NOT NULL,
    distributor_id bigint,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_items_id_seq OWNED BY public.line_items.id;


--
-- Name: localised_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.localised_addresses (
    id bigint NOT NULL,
    addressable_type character varying NOT NULL,
    addressable_id bigint NOT NULL,
    street character varying,
    city character varying,
    zip character varying,
    state character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lat numeric(15,10),
    lng numeric(15,10)
);


--
-- Name: localised_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.localised_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: localised_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.localised_addresses_id_seq OWNED BY public.localised_addresses.id;


--
-- Name: omni_importers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.omni_importers (
    id bigint NOT NULL,
    country_id integer,
    rules text,
    import_transaction_list character varying,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    payment_type character varying,
    bank_name character varying
);


--
-- Name: omni_importers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.omni_importers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: omni_importers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.omni_importers_id_seq OWNED BY public.omni_importers.id;


--
-- Name: order_extras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_extras (
    id bigint NOT NULL,
    order_id integer,
    extra_id integer,
    count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: order_extras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_extras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_extras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_extras_id_seq OWNED BY public.order_extras.id;


--
-- Name: order_schedule_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_schedule_transactions (
    id bigint NOT NULL,
    order_id bigint,
    schedule text,
    delivery_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: order_schedule_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_schedule_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_schedule_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_schedule_transactions_id_seq OWNED BY public.order_schedule_transactions.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    box_id bigint,
    quantity integer DEFAULT 1 NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id integer,
    active boolean DEFAULT false NOT NULL,
    extras_one_off boolean DEFAULT true,
    extras_packing_list_id integer
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages (
    id bigint NOT NULL,
    packing_list_id bigint,
    "position" integer,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    order_id integer,
    original_package_id integer,
    packing_method character varying,
    archived_address text,
    archived_order_quantity integer,
    archived_box_name character varying,
    archived_box_price_cents integer DEFAULT 0 NOT NULL,
    archived_customer_name character varying,
    archived_delivery_service_fee_cents integer DEFAULT 0 NOT NULL,
    archived_customer_discount numeric DEFAULT 0.0 NOT NULL,
    archived_extras text,
    archived_consumer_delivery_fee_cents integer DEFAULT 0,
    archived_substitutions text,
    archived_exclusions text,
    archived_address_details text
);


--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: packing_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packing_lists (
    id bigint NOT NULL,
    distributor_id bigint,
    date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: packing_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.packing_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packing_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.packing_lists_id_seq OWNED BY public.packing_lists.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    distributor_id bigint,
    account_id bigint,
    amount_cents integer DEFAULT 0 NOT NULL,
    kind character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reference character varying,
    reversed boolean,
    reversed_at timestamp without time zone,
    transaction_id integer,
    reversal_transaction_id integer,
    source character varying,
    display_time timestamp without time zone,
    payable_id integer,
    payable_type character varying
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: schedule_pauses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_pauses (
    id bigint NOT NULL,
    start date,
    finish date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schedule_pauses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_pauses_id_seq OWNED BY public.schedule_pauses.id;


--
-- Name: schedule_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_rules (
    id bigint NOT NULL,
    recur character varying,
    start date,
    mon boolean,
    tue boolean,
    wed boolean,
    thu boolean,
    fri boolean,
    sat boolean,
    sun boolean,
    schedule_pause_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    scheduleable_id integer,
    scheduleable_type character varying,
    halted boolean DEFAULT false,
    week integer DEFAULT 0
);


--
-- Name: schedule_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_rules_id_seq OWNED BY public.schedule_rules.id;


--
-- Name: schedule_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_transactions (
    id bigint NOT NULL,
    schedule_rule text,
    schedule_rule_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schedule_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_transactions_id_seq OWNED BY public.schedule_transactions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: substitutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.substitutions (
    id bigint NOT NULL,
    order_id bigint,
    line_item_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: substitutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.substitutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: substitutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.substitutions_id_seq OWNED BY public.substitutions.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id bigint NOT NULL,
    tag_id bigint,
    taggable_type character varying,
    taggable_id bigint,
    tagger_type character varying,
    tagger_id bigint,
    context character varying,
    created_at timestamp(6) without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    account_id bigint,
    amount_cents integer DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    transactionable_id integer,
    transactionable_type character varying,
    display_time timestamp without time zone,
    reverse_transactionable_id integer,
    reverse_transactionable_type character varying
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: bank_information id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_information ALTER COLUMN id SET DEFAULT nextval('public.bank_information_id_seq'::regclass);


--
-- Name: box_extras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_extras ALTER COLUMN id SET DEFAULT nextval('public.box_extras_id_seq'::regclass);


--
-- Name: boxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boxes ALTER COLUMN id SET DEFAULT nextval('public.boxes_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: cron_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cron_logs ALTER COLUMN id SET DEFAULT nextval('public.cron_logs_id_seq'::regclass);


--
-- Name: customer_checkouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_checkouts ALTER COLUMN id SET DEFAULT nextval('public.customer_checkouts_id_seq'::regclass);


--
-- Name: customer_logins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_logins ALTER COLUMN id SET DEFAULT nextval('public.customer_logins_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: deductions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deductions ALTER COLUMN id SET DEFAULT nextval('public.deductions_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN id SET DEFAULT nextval('public.deliveries_id_seq'::regclass);


--
-- Name: delivery_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists ALTER COLUMN id SET DEFAULT nextval('public.delivery_lists_id_seq'::regclass);


--
-- Name: delivery_sequence_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_sequence_orders ALTER COLUMN id SET DEFAULT nextval('public.delivery_sequence_orders_id_seq'::regclass);


--
-- Name: delivery_service_schedule_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_service_schedule_transactions ALTER COLUMN id SET DEFAULT nextval('public.delivery_service_schedule_transactions_id_seq'::regclass);


--
-- Name: delivery_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_services ALTER COLUMN id SET DEFAULT nextval('public.delivery_services_id_seq'::regclass);


--
-- Name: distributor_invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_invoices ALTER COLUMN id SET DEFAULT nextval('public.distributor_invoices_id_seq'::regclass);


--
-- Name: distributor_logins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_logins ALTER COLUMN id SET DEFAULT nextval('public.distributor_logins_id_seq'::regclass);


--
-- Name: distributor_pricings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_pricings ALTER COLUMN id SET DEFAULT nextval('public.distributor_pricings_id_seq'::regclass);


--
-- Name: distributors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors ALTER COLUMN id SET DEFAULT nextval('public.distributors_id_seq'::regclass);


--
-- Name: distributors_omni_importers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors_omni_importers ALTER COLUMN id SET DEFAULT nextval('public.distributors_omni_importers_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: exclusions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exclusions ALTER COLUMN id SET DEFAULT nextval('public.exclusions_id_seq'::regclass);


--
-- Name: extras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extras ALTER COLUMN id SET DEFAULT nextval('public.extras_id_seq'::regclass);


--
-- Name: import_transaction_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transaction_lists ALTER COLUMN id SET DEFAULT nextval('public.import_transaction_lists_id_seq'::regclass);


--
-- Name: import_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transactions ALTER COLUMN id SET DEFAULT nextval('public.import_transactions_id_seq'::regclass);


--
-- Name: line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_items ALTER COLUMN id SET DEFAULT nextval('public.line_items_id_seq'::regclass);


--
-- Name: localised_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localised_addresses ALTER COLUMN id SET DEFAULT nextval('public.localised_addresses_id_seq'::regclass);


--
-- Name: omni_importers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.omni_importers ALTER COLUMN id SET DEFAULT nextval('public.omni_importers_id_seq'::regclass);


--
-- Name: order_extras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_extras ALTER COLUMN id SET DEFAULT nextval('public.order_extras_id_seq'::regclass);


--
-- Name: order_schedule_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_schedule_transactions ALTER COLUMN id SET DEFAULT nextval('public.order_schedule_transactions_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: packing_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packing_lists ALTER COLUMN id SET DEFAULT nextval('public.packing_lists_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: schedule_pauses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_pauses ALTER COLUMN id SET DEFAULT nextval('public.schedule_pauses_id_seq'::regclass);


--
-- Name: schedule_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_rules ALTER COLUMN id SET DEFAULT nextval('public.schedule_rules_id_seq'::regclass);


--
-- Name: schedule_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_transactions ALTER COLUMN id SET DEFAULT nextval('public.schedule_transactions_id_seq'::regclass);


--
-- Name: substitutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitutions ALTER COLUMN id SET DEFAULT nextval('public.substitutions_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bank_information bank_information_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_information
    ADD CONSTRAINT bank_information_pkey PRIMARY KEY (id);


--
-- Name: box_extras box_extras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_extras
    ADD CONSTRAINT box_extras_pkey PRIMARY KEY (id);


--
-- Name: boxes boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boxes
    ADD CONSTRAINT boxes_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: cron_logs cron_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cron_logs
    ADD CONSTRAINT cron_logs_pkey PRIMARY KEY (id);


--
-- Name: customer_checkouts customer_checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_checkouts
    ADD CONSTRAINT customer_checkouts_pkey PRIMARY KEY (id);


--
-- Name: customer_logins customer_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_logins
    ADD CONSTRAINT customer_logins_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: deductions deductions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deductions
    ADD CONSTRAINT deductions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: delivery_lists delivery_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists
    ADD CONSTRAINT delivery_lists_pkey PRIMARY KEY (id);


--
-- Name: delivery_sequence_orders delivery_sequence_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_sequence_orders
    ADD CONSTRAINT delivery_sequence_orders_pkey PRIMARY KEY (id);


--
-- Name: delivery_service_schedule_transactions delivery_service_schedule_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_service_schedule_transactions
    ADD CONSTRAINT delivery_service_schedule_transactions_pkey PRIMARY KEY (id);


--
-- Name: delivery_services delivery_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_services
    ADD CONSTRAINT delivery_services_pkey PRIMARY KEY (id);


--
-- Name: distributor_invoices distributor_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_invoices
    ADD CONSTRAINT distributor_invoices_pkey PRIMARY KEY (id);


--
-- Name: distributor_logins distributor_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_logins
    ADD CONSTRAINT distributor_logins_pkey PRIMARY KEY (id);


--
-- Name: distributor_pricings distributor_pricings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_pricings
    ADD CONSTRAINT distributor_pricings_pkey PRIMARY KEY (id);


--
-- Name: distributors_omni_importers distributors_omni_importers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors_omni_importers
    ADD CONSTRAINT distributors_omni_importers_pkey PRIMARY KEY (id);


--
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exclusions exclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exclusions
    ADD CONSTRAINT exclusions_pkey PRIMARY KEY (id);


--
-- Name: extras extras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extras
    ADD CONSTRAINT extras_pkey PRIMARY KEY (id);


--
-- Name: import_transaction_lists import_transaction_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transaction_lists
    ADD CONSTRAINT import_transaction_lists_pkey PRIMARY KEY (id);


--
-- Name: import_transactions import_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transactions
    ADD CONSTRAINT import_transactions_pkey PRIMARY KEY (id);


--
-- Name: line_items line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_items
    ADD CONSTRAINT line_items_pkey PRIMARY KEY (id);


--
-- Name: localised_addresses localised_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localised_addresses
    ADD CONSTRAINT localised_addresses_pkey PRIMARY KEY (id);


--
-- Name: omni_importers omni_importers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.omni_importers
    ADD CONSTRAINT omni_importers_pkey PRIMARY KEY (id);


--
-- Name: order_extras order_extras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_extras
    ADD CONSTRAINT order_extras_pkey PRIMARY KEY (id);


--
-- Name: order_schedule_transactions order_schedule_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_schedule_transactions
    ADD CONSTRAINT order_schedule_transactions_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: packing_lists packing_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packing_lists
    ADD CONSTRAINT packing_lists_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: schedule_pauses schedule_pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_pauses
    ADD CONSTRAINT schedule_pauses_pkey PRIMARY KEY (id);


--
-- Name: schedule_rules schedule_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_rules
    ADD CONSTRAINT schedule_rules_pkey PRIMARY KEY (id);


--
-- Name: schedule_transactions schedule_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_transactions
    ADD CONSTRAINT schedule_transactions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: substitutions substitutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitutions
    ADD CONSTRAINT substitutions_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_accounts_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_customer_id ON public.accounts USING btree (customer_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_activities_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_customer_id ON public.activities USING btree (customer_id);


--
-- Name: index_addresses_on_address_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_address_hash ON public.addresses USING btree (address_hash);


--
-- Name: index_addresses_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_addresses_on_customer_id ON public.addresses USING btree (customer_id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_bank_information_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_information_on_distributor_id ON public.bank_information USING btree (distributor_id);


--
-- Name: index_boxes_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boxes_on_distributor_id ON public.boxes USING btree (distributor_id);


--
-- Name: index_countries_on_alpha2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_countries_on_alpha2 ON public.countries USING btree (alpha2);


--
-- Name: index_customers_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_authentication_token ON public.customers USING btree (authentication_token);


--
-- Name: index_customers_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_confirmation_token ON public.customers USING btree (confirmation_token);


--
-- Name: index_customers_on_delivery_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_delivery_service_id ON public.customers USING btree (delivery_service_id);


--
-- Name: index_customers_on_distributor_id_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_distributor_id_and_number ON public.customers USING btree (distributor_id, number);


--
-- Name: index_customers_on_email_and_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_email_and_distributor_id ON public.customers USING btree (email, distributor_id);


--
-- Name: index_customers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_reset_password_token ON public.customers USING btree (reset_password_token);


--
-- Name: index_customers_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_unlock_token ON public.customers USING btree (unlock_token);


--
-- Name: index_deductions_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deductions_on_account_id ON public.deductions USING btree (account_id);


--
-- Name: index_deductions_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deductions_on_distributor_id ON public.deductions USING btree (distributor_id);


--
-- Name: index_deliveries_on_delivery_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deliveries_on_delivery_list_id ON public.deliveries USING btree (delivery_list_id);


--
-- Name: index_deliveries_on_delivery_list_id_and_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_deliveries_on_delivery_list_id_and_order_id ON public.deliveries USING btree (delivery_list_id, order_id);


--
-- Name: index_deliveries_on_delivery_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deliveries_on_delivery_service_id ON public.deliveries USING btree (delivery_service_id);


--
-- Name: index_deliveries_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deliveries_on_order_id ON public.deliveries USING btree (order_id);


--
-- Name: index_deliveries_on_package_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deliveries_on_package_id ON public.deliveries USING btree (package_id);


--
-- Name: index_delivery_lists_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_lists_on_distributor_id ON public.delivery_lists USING btree (distributor_id);


--
-- Name: index_delivery_service_schedule_transactions_on_ds_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_service_schedule_transactions_on_ds_id ON public.delivery_service_schedule_transactions USING btree (delivery_service_id);


--
-- Name: index_delivery_services_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_services_on_distributor_id ON public.delivery_services USING btree (distributor_id);


--
-- Name: index_distributor_invoices_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_invoices_on_distributor_id ON public.distributor_invoices USING btree (distributor_id);


--
-- Name: index_distributor_pricings_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_pricings_on_distributor_id ON public.distributor_pricings USING btree (distributor_id);


--
-- Name: index_distributors_on_api_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_distributors_on_api_key ON public.distributors USING btree (api_key);


--
-- Name: index_events_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_distributor_id ON public.events USING btree (distributor_id);


--
-- Name: index_exclusions_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exclusions_on_line_item_id ON public.exclusions USING btree (line_item_id);


--
-- Name: index_exclusions_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exclusions_on_order_id ON public.exclusions USING btree (order_id);


--
-- Name: index_import_draft; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_draft ON public.import_transactions USING btree (import_transaction_list_id, draft);


--
-- Name: index_import_match; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_match ON public.import_transactions USING btree (import_transaction_list_id, match);


--
-- Name: index_import_removed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_removed ON public.import_transactions USING btree (import_transaction_list_id, removed);


--
-- Name: index_import_transaction_lists_on_distributor_id_and_draft; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_transaction_lists_on_distributor_id_and_draft ON public.import_transaction_lists USING btree (distributor_id, draft);


--
-- Name: index_import_transactions_on_import_transaction_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_transactions_on_import_transaction_list_id ON public.import_transactions USING btree (import_transaction_list_id);


--
-- Name: index_line_items_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_items_on_distributor_id ON public.line_items USING btree (distributor_id);


--
-- Name: index_localised_addresses_on_addressable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_localised_addresses_on_addressable ON public.localised_addresses USING btree (addressable_type, addressable_id);


--
-- Name: index_order_schedule_transactions_on_delivery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_schedule_transactions_on_delivery_id ON public.order_schedule_transactions USING btree (delivery_id);


--
-- Name: index_order_schedule_transactions_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_schedule_transactions_on_order_id ON public.order_schedule_transactions USING btree (order_id);


--
-- Name: index_orders_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_account_id ON public.orders USING btree (account_id);


--
-- Name: index_orders_on_box_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_box_id ON public.orders USING btree (box_id);


--
-- Name: index_packages_on_original_package_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_on_original_package_id ON public.packages USING btree (original_package_id);


--
-- Name: index_packages_on_packing_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_on_packing_list_id ON public.packages USING btree (packing_list_id);


--
-- Name: index_packages_on_packing_list_id_and_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_packages_on_packing_list_id_and_order_id ON public.packages USING btree (packing_list_id, order_id);


--
-- Name: index_packing_lists_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packing_lists_on_distributor_id ON public.packing_lists USING btree (distributor_id);


--
-- Name: index_payments_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_account_id ON public.payments USING btree (account_id);


--
-- Name: index_payments_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_distributor_id ON public.payments USING btree (distributor_id);


--
-- Name: index_substitutions_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_substitutions_on_line_item_id ON public.substitutions USING btree (line_item_id);


--
-- Name: index_substitutions_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_substitutions_on_order_id ON public.substitutions USING btree (order_id);


--
-- Name: index_taggings_on_taggable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable ON public.taggings USING btree (taggable_type, taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_tagger; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger ON public.taggings USING btree (tagger_type, tagger_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_transactions_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_account_id ON public.transactions USING btree (account_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20111129095356'),
('20111130231744'),
('20111201005231'),
('20111201065712'),
('20111201080900'),
('20111201095437'),
('20111202014435'),
('20111202030831'),
('20111202203846'),
('20111202223623'),
('20111203023947'),
('20111203043450'),
('20111203044422'),
('20111203124951'),
('20111205001329'),
('20111205004252'),
('20111205005039'),
('20111205082509'),
('20111205230751'),
('20111213104609'),
('20111216002214'),
('20111216003519'),
('20111216041303'),
('20111216044030'),
('20111216112600'),
('20111218221013'),
('20111219234909'),
('20111220042841'),
('20111220115128'),
('20111228012130'),
('20120104235552'),
('20120108085002'),
('20120110034608'),
('20120110035632'),
('20120110113524'),
('20120114105104'),
('20120114115648'),
('20120115034534'),
('20120119010559'),
('20120119011621'),
('20120119034927'),
('20120119234154'),
('20120119234748'),
('20120120001658'),
('20120120020534'),
('20120123215057'),
('20120124085202'),
('20120124100740'),
('20120124215818'),
('20120124224311'),
('20120124224707'),
('20120125020712'),
('20120126102057'),
('20120129003124'),
('20120129041416'),
('20120129220207'),
('20120130030201'),
('20120131081149'),
('20120201002517'),
('20120201233808'),
('20120202022849'),
('20120207040356'),
('20120215011432'),
('20120215013339'),
('20120215013725'),
('20120216100258'),
('20120223062300'),
('20120223234648'),
('20120226211014'),
('20120227092736'),
('20120228003940'),
('20120228033613'),
('20120228081323'),
('20120228210358'),
('20120229005336'),
('20120229043436'),
('20120302024839'),
('20120306032019'),
('20120307040041'),
('20120307232215'),
('20120320030645'),
('20120329013333'),
('20120329014157'),
('20120329014224'),
('20120329014401'),
('20120329014533'),
('20120410023926'),
('20120417225545'),
('20120426220552'),
('20120430023506'),
('20120430024101'),
('20120501015452'),
('20120501031349'),
('20120501032413'),
('20120516044556'),
('20120517001659'),
('20120517011651'),
('20120521041038'),
('20120522033509'),
('20120530080733'),
('20120605050350'),
('20120607032427'),
('20120607041557'),
('20120611011844'),
('20120611015841'),
('20120613015239'),
('20120613082157'),
('20120614000606'),
('20120617101936'),
('20120627235129'),
('20120627235203'),
('20120629013033'),
('20120718235146'),
('20120724025411'),
('20120726014507'),
('20120730233824'),
('20120812232427'),
('20120815061732'),
('20120815081106'),
('20120815093134'),
('20120820040446'),
('20120822031706'),
('20120829004318'),
('20120830003818'),
('20120831022656'),
('20120904051101'),
('20120904052651'),
('20120909041708'),
('20120910034809'),
('20120911033835'),
('20120917054659'),
('20120918113919'),
('20120919000442'),
('20120920231722'),
('20120923230255'),
('20120927040432'),
('20120927042204'),
('20120927055104'),
('20120927224520'),
('20120929040236'),
('20121002212248'),
('20121003205726'),
('20121010231051'),
('20121010232812'),
('20121010236717'),
('20121018021812'),
('20121024025935'),
('20121102225050'),
('20121112232854'),
('20121114225113'),
('20121116015952'),
('20121119000156'),
('20121119005042'),
('20121128005022'),
('20121204015243'),
('20121211024951'),
('20121211222422'),
('20121212212609'),
('20130110013104'),
('20130116031833'),
('20130122003352'),
('20130123022020'),
('20130125004824'),
('20130128022723'),
('20130130220514'),
('20130213020709'),
('20130213224528'),
('20130218060217'),
('20130219014308'),
('20130220234725'),
('20130222011927'),
('20130226231819'),
('20130227051525'),
('20130228205052'),
('20130305134300'),
('20130306001542'),
('20130306002347'),
('20130306003517'),
('20130306003632'),
('20130307233033'),
('20130308022028'),
('20130311224428'),
('20130313051530'),
('20130315034909'),
('20130321040949'),
('20130409022821'),
('20130416022347'),
('20130417021024'),
('20130417025820'),
('20130423225325'),
('20130429060902'),
('20130430034158'),
('20130430034231'),
('20130508035922'),
('20130509012650'),
('20130510023753'),
('20130514032841'),
('20130514034901'),
('20130515012606'),
('20130610041926'),
('20130610110940'),
('20130610121509'),
('20130616094641'),
('20130617051437'),
('20130625112501'),
('20130703031111'),
('20130703055630'),
('20130705011742'),
('20130705053401'),
('20130710053124'),
('20130730021915'),
('20130820025105'),
('20130826015549'),
('20130826051545'),
('20130827002646'),
('20130910033818'),
('20130923050455'),
('20130926033607'),
('20131016215622'),
('20131016215636'),
('20131020234439'),
('20131022003933'),
('20131022015514'),
('20131022025554'),
('20131106103858'),
('20131112025426'),
('20131212220220'),
('20131216225521'),
('20140109004934'),
('20140109032329'),
('20140513204743'),
('20140518211720'),
('20140612130409'),
('20140713222406'),
('20140718175650'),
('20140922105032'),
('20150328193017'),
('20150414181412'),
('20150414184421'),
('20150422185555'),
('20150504072003'),
('20150508150013'),
('20150622122103'),
('20150630195411'),
('20150815161649'),
('20150815161650'),
('20150815161651'),
('20150815161652'),
('20151021130722'),
('20151120191928'),
('20151126143915'),
('20160102123920'),
('20160102181716'),
('20160318091706'),
('20160418141933'),
('20160419122414'),
('20160527220835'),
('20161012105035'),
('20161015092717'),
('20161018203706'),
('20161019140533'),
('20200626151920'),
('20200708091011'),
('20220118132922'),
('20220119134058'),
('20220119134059'),
('20220119134060');


