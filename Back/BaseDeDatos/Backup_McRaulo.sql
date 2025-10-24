--
-- PostgreSQL database dump
--

\restrict Asv0pRB9l7tplkYMETg6HdXgqtvHrxBRw9ABh7oVNXyYQxsiW068W2ACWI4DzY0

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-20 16:41:06

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 13 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 402 (class 1255 OID 17271)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW(); -- Asigna la fecha y hora actual a la columna updated_at del nuevo registro.
    RETURN NEW; -- Retorna el nuevo registro modificado.
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 266 (class 1259 OID 18843)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    nombre character varying(255) NOT NULL,
    apellido character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    telefono character varying(50),
    id_tipo_contribuyente integer,
    fecha_registro timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    es_socio boolean DEFAULT false,
    descuento_porcentaje integer DEFAULT 10,
    saldo_puntos integer DEFAULT 0
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 18849)
-- Name: cliente_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 267
-- Name: cliente_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.clientes.id_cliente;


--
-- TOC entry 268 (class 1259 OID 18850)
-- Name: cupon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cupon (
    id_cupon integer NOT NULL,
    id_cupon_predefinido integer NOT NULL,
    id_cliente integer,
    codigo_unico character varying(100),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento timestamp without time zone,
    usos_restantes integer DEFAULT 1,
    aplicado boolean DEFAULT false,
    fecha_aplicacion timestamp without time zone,
    CONSTRAINT chk_usos_restantes CHECK ((usos_restantes >= 0))
);


ALTER TABLE public.cupon OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 18857)
-- Name: cupon_id_cupon_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cupon_id_cupon_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cupon_id_cupon_seq OWNER TO postgres;

--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 269
-- Name: cupon_id_cupon_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cupon_id_cupon_seq OWNED BY public.cupon.id_cupon;


--
-- TOC entry 270 (class 1259 OID 18858)
-- Name: cupon_predefinido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cupon_predefinido (
    id_cupon_predefinido integer NOT NULL,
    codigo character varying(50) NOT NULL,
    tipo_descuento character varying(20) NOT NULL,
    valor_descuento numeric(10,2),
    monto_minimo_compra numeric(10,2),
    fecha_inicio_validez date NOT NULL,
    fecha_fin_validez date NOT NULL,
    limite_usos_por_cliente integer,
    limite_usos_total integer,
    activo boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cupon_predefinido OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 18864)
-- Name: cupon_predefinido_id_cupon_predefinido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq OWNER TO postgres;

--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 271
-- Name: cupon_predefinido_id_cupon_predefinido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq OWNED BY public.cupon_predefinido.id_cupon_predefinido;


--
-- TOC entry 293 (class 1259 OID 78825)
-- Name: cupones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cupones (
    id_cupon integer NOT NULL,
    codigo character varying(50) NOT NULL,
    id_cliente integer NOT NULL,
    descuento_porcentaje integer NOT NULL,
    usado boolean DEFAULT false,
    id_pedido_usado integer,
    fecha_generado timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion timestamp without time zone NOT NULL,
    fecha_uso timestamp without time zone
);


ALTER TABLE public.cupones OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 18865)
-- Name: estado_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estado_pedido (
    id_estado_pedido integer NOT NULL,
    nombre character varying(255) NOT NULL
);


ALTER TABLE public.estado_pedido OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 18868)
-- Name: estado_pedido_id_estado_pedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estado_pedido_id_estado_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estado_pedido_id_estado_pedido_seq OWNER TO postgres;

--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 273
-- Name: estado_pedido_id_estado_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estado_pedido_id_estado_pedido_seq OWNED BY public.estado_pedido.id_estado_pedido;


--
-- TOC entry 274 (class 1259 OID 18869)
-- Name: ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredientes (
    id_ingrediente integer NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    precio numeric(10,2) DEFAULT 0.00 NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    unidad_medida character varying(50)
);


ALTER TABLE public.ingredientes OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 18876)
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredientes_id_ingrediente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredientes_id_ingrediente_seq OWNER TO postgres;

--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 275
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredientes_id_ingrediente_seq OWNED BY public.ingredientes.id_ingrediente;


--
-- TOC entry 276 (class 1259 OID 18877)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id_pedido integer NOT NULL,
    fecha_hora timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    id_estado_pedido integer NOT NULL,
    total numeric(10,2) DEFAULT 0.00 NOT NULL,
    id_tipo_pago integer NOT NULL,
    id_cliente integer NOT NULL,
    subtotal numeric(10,2) DEFAULT 0.00 NOT NULL,
    descuento_total numeric(10,2) DEFAULT 0.00 NOT NULL,
    id_cupon_aplicado integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    activo boolean DEFAULT true,
    fecha_eliminacion timestamp with time zone,
    tipo_servicio character varying(50),
    descuento_aplicado numeric(10,2) DEFAULT 0,
    id_cupon_usado integer,
    id_socio integer,
    CONSTRAINT chk_descuento_no_mayor_que_total CHECK ((descuento_total <= total)),
    CONSTRAINT chk_descuento_no_negativo CHECK ((descuento_total >= (0)::numeric)),
    CONSTRAINT chk_total_positivo CHECK ((total > (0)::numeric))
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 18889)
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_pedido_seq OWNER TO postgres;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 277
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_pedido_seq OWNED BY public.pedidos.id_pedido;


--
-- TOC entry 278 (class 1259 OID 18890)
-- Name: pedidos_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos_productos (
    id_pedido_producto integer NOT NULL,
    id_pedido integer NOT NULL,
    id_producto integer NOT NULL,
    subtotal numeric(10,2) DEFAULT 0.00 NOT NULL,
    cantidad integer DEFAULT 1 NOT NULL,
    notas text,
    CONSTRAINT pedidos_productos_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.pedidos_productos OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 18898)
-- Name: pedidos_productos_id_pedido_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_productos_id_pedido_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_productos_id_pedido_producto_seq OWNER TO postgres;

--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 279
-- Name: pedidos_productos_id_pedido_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_productos_id_pedido_producto_seq OWNED BY public.pedidos_productos.id_pedido_producto;


--
-- TOC entry 280 (class 1259 OID 18899)
-- Name: pedidos_productos_ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos_productos_ingredientes (
    id_pedido_producto integer NOT NULL,
    id_ingrediente integer NOT NULL,
    cantidad numeric(10,2) DEFAULT 0.00 NOT NULL,
    es_extra boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pedidos_productos_ingredientes OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 18904)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id_producto integer NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    precio_base numeric(10,2) DEFAULT 0.00 NOT NULL,
    categoria character varying(255),
    disponible boolean DEFAULT true NOT NULL
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 18911)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_producto_seq OWNER TO postgres;

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 282
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_producto_seq OWNED BY public.productos.id_producto;


--
-- TOC entry 283 (class 1259 OID 18912)
-- Name: productos_ingredientes_base; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos_ingredientes_base (
    id_producto integer NOT NULL,
    id_ingrediente integer NOT NULL,
    cantidad numeric(10,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.productos_ingredientes_base OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 84462)
-- Name: socios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socios (
    id_socio integer NOT NULL,
    dni character varying(8) NOT NULL,
    nombre character varying(100),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true
);


ALTER TABLE public.socios OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 84461)
-- Name: socios_id_socio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socios_id_socio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socios_id_socio_seq OWNER TO postgres;

--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 296
-- Name: socios_id_socio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.socios_id_socio_seq OWNED BY public.socios.id_socio;


--
-- TOC entry 284 (class 1259 OID 18916)
-- Name: tipo_contribuyente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_contribuyente (
    id_tipo_contribuyente integer NOT NULL,
    nombre character varying(255) NOT NULL
);


ALTER TABLE public.tipo_contribuyente OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 18919)
-- Name: tipo_contribuyente_id_tipo_contribuyente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq OWNER TO postgres;

--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 285
-- Name: tipo_contribuyente_id_tipo_contribuyente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq OWNED BY public.tipo_contribuyente.id_tipo_contribuyente;


--
-- TOC entry 286 (class 1259 OID 18920)
-- Name: tipo_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_pago (
    id_tipo_pago integer NOT NULL,
    nombre character varying(255) NOT NULL
);


ALTER TABLE public.tipo_pago OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 18923)
-- Name: tipo_pago_id_tipo_pago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_pago_id_tipo_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_pago_id_tipo_pago_seq OWNER TO postgres;

--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 287
-- Name: tipo_pago_id_tipo_pago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_pago_id_tipo_pago_seq OWNED BY public.tipo_pago.id_tipo_pago;


--
-- TOC entry 288 (class 1259 OID 18924)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    id_cliente integer,
    rol character varying(50) DEFAULT 'cliente'::character varying
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 18930)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 289
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- TOC entry 3572 (class 2604 OID 18931)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_id_cliente_seq'::regclass);


--
-- TOC entry 3577 (class 2604 OID 18932)
-- Name: cupon id_cupon; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon ALTER COLUMN id_cupon SET DEFAULT nextval('public.cupon_id_cupon_seq'::regclass);


--
-- TOC entry 3581 (class 2604 OID 18933)
-- Name: cupon_predefinido id_cupon_predefinido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon_predefinido ALTER COLUMN id_cupon_predefinido SET DEFAULT nextval('public.cupon_predefinido_id_cupon_predefinido_seq'::regclass);


--
-- TOC entry 3585 (class 2604 OID 18934)
-- Name: estado_pedido id_estado_pedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_pedido ALTER COLUMN id_estado_pedido SET DEFAULT nextval('public.estado_pedido_id_estado_pedido_seq'::regclass);


--
-- TOC entry 3586 (class 2604 OID 18935)
-- Name: ingredientes id_ingrediente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes ALTER COLUMN id_ingrediente SET DEFAULT nextval('public.ingredientes_id_ingrediente_seq'::regclass);


--
-- TOC entry 3589 (class 2604 OID 18936)
-- Name: pedidos id_pedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id_pedido SET DEFAULT nextval('public.pedidos_id_pedido_seq'::regclass);


--
-- TOC entry 3597 (class 2604 OID 18937)
-- Name: pedidos_productos id_pedido_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos ALTER COLUMN id_pedido_producto SET DEFAULT nextval('public.pedidos_productos_id_pedido_producto_seq'::regclass);


--
-- TOC entry 3602 (class 2604 OID 18938)
-- Name: productos id_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id_producto SET DEFAULT nextval('public.productos_id_producto_seq'::regclass);


--
-- TOC entry 3612 (class 2604 OID 84465)
-- Name: socios id_socio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socios ALTER COLUMN id_socio SET DEFAULT nextval('public.socios_id_socio_seq'::regclass);


--
-- TOC entry 3606 (class 2604 OID 18939)
-- Name: tipo_contribuyente id_tipo_contribuyente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente ALTER COLUMN id_tipo_contribuyente SET DEFAULT nextval('public.tipo_contribuyente_id_tipo_contribuyente_seq'::regclass);


--
-- TOC entry 3607 (class 2604 OID 18940)
-- Name: tipo_pago id_tipo_pago; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago ALTER COLUMN id_tipo_pago SET DEFAULT nextval('public.tipo_pago_id_tipo_pago_seq'::regclass);


--
-- TOC entry 3608 (class 2604 OID 18941)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 3843 (class 0 OID 18843)
-- Dependencies: 266
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes VALUES (4, 'Cliente', 'Principal', 'principal@example.com', NULL, 4, '2025-07-17 06:45:30.257914+00', false, 10, 0);
INSERT INTO public.clientes VALUES (5, 'Cliente', 'Secundario', 'secundario@example.com', NULL, 5, '2025-07-17 06:45:30.257914+00', false, 10, 0);
INSERT INTO public.clientes VALUES (6, 'Cliente', 'VIP', 'vip@example.com', NULL, 6, '2025-07-17 06:45:30.257914+00', false, 10, 0);
INSERT INTO public.clientes VALUES (10, 'Juan', 'Perez', 'juan.perez@example.com', '123456789', NULL, '2025-07-24 20:01:04.80293+00', false, 10, 0);
INSERT INTO public.clientes VALUES (17, 'Juan roman', 'Perez', 'juan.perezok@example.com', '693456789', 4, '2025-07-26 00:07:33.990335+00', false, 10, 0);
INSERT INTO public.clientes VALUES (18, 'Ana', 'Gomez', 'ana.gomez@example.com', '987654321', 5, '2025-07-26 00:20:17.997435+00', false, 10, 0);
INSERT INTO public.clientes VALUES (21, 'Guan', 'Pérez', 'juan.peez@example.com', '1122338455', 4, '2025-08-12 13:42:55.8249+00', false, 10, 0);
INSERT INTO public.clientes VALUES (22, 'Agustin', 'Pérez', 'agustin.perez@email.com', '3512345678', NULL, '2025-10-13 14:18:04.666932+00', true, 10, 0);
INSERT INTO public.clientes VALUES (23, 'Mario', 'González', 'mario.gonzalez@email.com', '3519876543', NULL, '2025-10-13 14:18:04.666932+00', true, 10, 50);
INSERT INTO public.clientes VALUES (24, 'Genaro', 'Rodríguez', 'genaro.rodriguez@email.com', '3514567890', NULL, '2025-10-13 14:18:04.666932+00', true, 15, 100);
INSERT INTO public.clientes VALUES (25, 'Selena', 'Martínez', 'selena.martinez@email.com', '3513334455', NULL, '2025-10-13 14:18:04.666932+00', false, 0, 0);
INSERT INTO public.clientes VALUES (26, 'Jose', 'Leones', 'jose.leones@email.com', '3517778899', NULL, '2025-10-13 14:18:04.666932+00', false, 0, 0);


--
-- TOC entry 3845 (class 0 OID 18850)
-- Dependencies: 268
-- Data for Name: cupon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cupon VALUES (3, 1, 4, 'CUPON_TEST_001', '2025-07-26 00:48:21.605789', '2026-07-17 23:59:59', 1, false, NULL);


--
-- TOC entry 3847 (class 0 OID 18858)
-- Dependencies: 270
-- Data for Name: cupon_predefinido; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cupon_predefinido VALUES (1, 'PRIMERA_COMPRA', 'porcentaje', 0.15, 25.00, '2025-07-17', '2026-07-17', 1, NULL, true, '2025-07-17 16:50:26.307208', '2025-07-17 16:50:26.307208');
INSERT INTO public.cupon_predefinido VALUES (2, 'LEALTAD_JULIO', 'monto_fijo', 7.50, 40.00, '2025-07-01', '2025-07-31', NULL, NULL, true, '2025-07-17 16:50:26.307208', '2025-07-17 16:50:26.307208');
INSERT INTO public.cupon_predefinido VALUES (3, 'OFERTA_NAVIDAD_2025', 'monto_fijo', 10.00, 50.00, '2025-12-01', '2025-12-31', 1, 200, true, '2025-07-26 17:14:58.677936', '2025-07-26 17:14:58.677936');


--
-- TOC entry 3867 (class 0 OID 78825)
-- Dependencies: 293
-- Data for Name: cupones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3849 (class 0 OID 18865)
-- Dependencies: 272
-- Data for Name: estado_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.estado_pedido VALUES (6, 'pendiente');
INSERT INTO public.estado_pedido VALUES (7, 'entregado');
INSERT INTO public.estado_pedido VALUES (8, 'en_preparacion');
INSERT INTO public.estado_pedido VALUES (9, 'cancelado');
INSERT INTO public.estado_pedido VALUES (10, 'en_camino');


--
-- TOC entry 3851 (class 0 OID 18869)
-- Dependencies: 274
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredientes VALUES (16, 'Pan de hamburguesa', 'Pan brioche para hamburguesa', 0.50, 500, 'unidad');
INSERT INTO public.ingredientes VALUES (17, 'Carne de res', 'Medallón de carne de res 150g', 2.50, 300, 'unidad');
INSERT INTO public.ingredientes VALUES (18, 'Pollo crispy', 'Medallón de pollo rebozado 120g', 2.00, 200, 'unidad');
INSERT INTO public.ingredientes VALUES (19, 'Medallón veggie', 'Medallón de proteína vegetal 120g', 2.50, 150, 'unidad');
INSERT INTO public.ingredientes VALUES (20, 'Queso cheddar', 'Feta de queso cheddar', 0.75, 400, 'unidad');
INSERT INTO public.ingredientes VALUES (21, 'Lechuga', 'Lechuga fresca', 0.30, 5000, 'g');
INSERT INTO public.ingredientes VALUES (22, 'Tomate', 'Rodaja de tomate', 0.40, 10000, 'g');
INSERT INTO public.ingredientes VALUES (23, 'Cebolla', 'Cebolla en rodajas', 0.30, 8000, 'g');
INSERT INTO public.ingredientes VALUES (24, 'Pepinillos', 'Pepinillos en rodajas', 0.50, 3000, 'g');
INSERT INTO public.ingredientes VALUES (25, 'Bacon', 'Tiras de bacon crujiente', 1.50, 5000, 'g');
INSERT INTO public.ingredientes VALUES (26, 'Salsa especial', 'Salsa especial de la casa', 0.50, 10000, 'ml');
INSERT INTO public.ingredientes VALUES (27, 'Ketchup', 'Salsa de tomate', 0.20, 15000, 'ml');
INSERT INTO public.ingredientes VALUES (28, 'Mostaza', 'Mostaza amarilla', 0.20, 12000, 'ml');
INSERT INTO public.ingredientes VALUES (29, 'Mayonesa', 'Mayonesa casera', 0.30, 10000, 'ml');
INSERT INTO public.ingredientes VALUES (30, 'Guacamole', 'Guacamole fresco', 1.20, 5000, 'g');
INSERT INTO public.ingredientes VALUES (46, 'Pimienta Negra', 'Pimienta negra molida', 2.50, 300, 'gramos');


--
-- TOC entry 3853 (class 0 OID 18877)
-- Dependencies: 276
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedidos VALUES (5, '2025-07-24 10:00:00+00', 8, 150.75, 5, 4, 0.00, 9.25, NULL, '2025-07-24 19:54:16.696616+00', NULL, true, NULL, NULL, 0.00, NULL, NULL);
INSERT INTO public.pedidos VALUES (6, '2025-07-24 10:00:00+00', 9, 150.75, 5, 4, 0.00, 9.25, NULL, '2025-07-24 20:25:53.652326+00', NULL, true, NULL, NULL, 0.00, NULL, NULL);
INSERT INTO public.pedidos VALUES (7, '2025-07-24 10:00:00+00', 10, 180.50, 5, 4, 190.00, 9.50, NULL, '2025-07-24 20:35:39.427928+00', '2025-07-24 21:18:54.097446+00', true, NULL, NULL, 0.00, NULL, NULL);
INSERT INTO public.pedidos VALUES (15, '2025-08-13 12:17:16.738641+00', 8, 50.00, 5, 4, 50.00, 0.00, NULL, '2025-08-13 12:17:16.738641+00', NULL, true, NULL, 'llevar', 0.00, NULL, NULL);


--
-- TOC entry 3855 (class 0 OID 18890)
-- Dependencies: 278
-- Data for Name: pedidos_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedidos_productos VALUES (1, 2, 11, 11.69, 1, 'Sin cebolla, con bacon extra y guacamole extra');
INSERT INTO public.pedidos_productos VALUES (2, 2, 14, 3.99, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (3, 2, 16, 2.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (4, 2, 16, 2.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (5, 2, 20, 1.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (6, 3, 12, 10.74, 1, 'Con queso extra');
INSERT INTO public.pedidos_productos VALUES (7, 3, 13, 9.49, 1, 'Sin tomate, bien cocido');
INSERT INTO public.pedidos_productos VALUES (8, 3, 15, 5.99, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (9, 3, 19, 3.50, 1, 'Con poco hielo');
INSERT INTO public.pedidos_productos VALUES (10, 4, 11, 8.99, 1, 'Normal, sin modificaciones');
INSERT INTO public.pedidos_productos VALUES (11, 4, 11, 10.49, 1, 'Sin lechuga, con bacon extra');
INSERT INTO public.pedidos_productos VALUES (12, 4, 11, 11.49, 1, 'Sin cebolla, sin tomate, doble queso, con guacamole');
INSERT INTO public.pedidos_productos VALUES (13, 5, 11, 11.69, 1, 'Sin cebolla, con bacon extra y guacamole extra');
INSERT INTO public.pedidos_productos VALUES (14, 5, 14, 3.99, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (15, 5, 16, 2.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (16, 5, 16, 2.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (17, 5, 20, 1.50, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (18, 6, 12, 10.74, 1, 'Con queso extra');
INSERT INTO public.pedidos_productos VALUES (19, 6, 13, 9.49, 1, 'Sin tomate, bien cocido');
INSERT INTO public.pedidos_productos VALUES (20, 6, 15, 5.99, 1, NULL);
INSERT INTO public.pedidos_productos VALUES (22, 7, 11, 8.99, 1, 'Normal, sin modificaciones');
INSERT INTO public.pedidos_productos VALUES (23, 7, 11, 10.49, 1, 'Sin lechuga, con bacon extra');
INSERT INTO public.pedidos_productos VALUES (24, 7, 11, 11.49, 1, 'Sin cebolla, sin tomate, doble queso, con guacamole');
INSERT INTO public.pedidos_productos VALUES (25, 7, 15, 12.99, 1, 'Sin cebolla');
INSERT INTO public.pedidos_productos VALUES (26, 7, 15, 12.99, 1, 'Sin cebolla');


--
-- TOC entry 3857 (class 0 OID 18899)
-- Dependencies: 280
-- Data for Name: pedidos_productos_ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedidos_productos_ingredientes VALUES (1, 23, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (1, 25, 2.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (1, 30, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (6, 20, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (7, 22, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (11, 21, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (11, 25, 2.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (12, 23, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (12, 22, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (12, 20, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (12, 30, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (13, 23, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (13, 25, 2.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (13, 30, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (18, 20, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (19, 22, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (23, 21, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (23, 25, 2.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (24, 23, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (24, 22, 0.00, false);
INSERT INTO public.pedidos_productos_ingredientes VALUES (24, 20, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (24, 30, 1.00, true);
INSERT INTO public.pedidos_productos_ingredientes VALUES (9, 18, 50.00, true);


--
-- TOC entry 3858 (class 0 OID 18904)
-- Dependencies: 281
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.productos VALUES (11, 'McRaulo Cheese', 'Hamburguesa clásica con queso cheddar', 8.99, 'hamburguesa', true);
INSERT INTO public.productos VALUES (12, 'McRaulo Veggie', 'Hamburguesa vegetariana con proteína de soja', 9.99, 'hamburguesa', true);
INSERT INTO public.productos VALUES (13, 'McRaulo Pollo', 'Hamburguesa de pollo crujiente', 9.49, 'hamburguesa', true);
INSERT INTO public.productos VALUES (14, 'Papas fritas', 'Papas fritas crujientes', 3.99, 'acompañamiento', true);
INSERT INTO public.productos VALUES (15, 'Papas con cheddar', 'Papas fritas con queso cheddar derretido', 5.99, 'acompañamiento', true);
INSERT INTO public.productos VALUES (16, 'Coca-Cola', 'Refresco de cola 500ml', 2.50, 'bebida', true);
INSERT INTO public.productos VALUES (17, 'Sprite', 'Refresco de lima-limón 500ml', 2.50, 'bebida', true);
INSERT INTO public.productos VALUES (18, 'Fanta', 'Refresco de naranja 500ml', 2.50, 'bebida', true);
INSERT INTO public.productos VALUES (19, 'Limonada', 'Limonada natural 500ml', 3.50, 'bebida', true);
INSERT INTO public.productos VALUES (20, 'Agua mineral', 'Agua mineral 500ml', 1.50, 'bebida', true);


--
-- TOC entry 3860 (class 0 OID 18912)
-- Dependencies: 283
-- Data for Name: productos_ingredientes_base; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.productos_ingredientes_base VALUES (11, 16, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 17, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 20, 2.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 21, 20.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 22, 30.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 23, 15.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 26, 15.00);
INSERT INTO public.productos_ingredientes_base VALUES (11, 27, 10.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 16, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 19, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 20, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 21, 25.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 22, 30.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 23, 15.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 24, 15.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 26, 15.00);
INSERT INTO public.productos_ingredientes_base VALUES (12, 29, 10.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 16, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 18, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 20, 1.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 21, 20.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 22, 30.00);
INSERT INTO public.productos_ingredientes_base VALUES (13, 29, 15.00);


--
-- TOC entry 3869 (class 0 OID 84462)
-- Dependencies: 297
-- Data for Name: socios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.socios VALUES (1, '46658908', 'Nuevo socio', '2025-10-18 23:56:37.261366', true);
INSERT INTO public.socios VALUES (2, '45645465', 'Nuevo socio', '2025-10-19 00:36:03.017296', true);


--
-- TOC entry 3861 (class 0 OID 18916)
-- Dependencies: 284
-- Data for Name: tipo_contribuyente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_contribuyente VALUES (4, 'Consumidor Final');
INSERT INTO public.tipo_contribuyente VALUES (5, 'Monotributista');
INSERT INTO public.tipo_contribuyente VALUES (6, 'Responsable Inscripto');


--
-- TOC entry 3863 (class 0 OID 18920)
-- Dependencies: 286
-- Data for Name: tipo_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_pago VALUES (5, 'efectivo');
INSERT INTO public.tipo_pago VALUES (7, 'mercadopago');


--
-- TOC entry 3865 (class 0 OID 18924)
-- Dependencies: 288
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios VALUES (1, 'vero.administrador@example.com', '$2b$10$ig21WG.aqYSDpfJEYrhI0e4iJmlUS.D35RB88nsNpC9GXdsoKrczu', 21, 'cliente');


--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 267
-- Name: cliente_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_cliente_seq', 26, true);


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 269
-- Name: cupon_id_cupon_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cupon_id_cupon_seq', 3, true);


--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 271
-- Name: cupon_predefinido_id_cupon_predefinido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cupon_predefinido_id_cupon_predefinido_seq', 3, true);


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 273
-- Name: estado_pedido_id_estado_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estado_pedido_id_estado_pedido_seq', 16, true);


--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 275
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredientes_id_ingrediente_seq', 47, true);


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 277
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_pedido_seq', 15, true);


--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 279
-- Name: pedidos_productos_id_pedido_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_productos_id_pedido_producto_seq', 26, true);


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 282
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_producto_seq', 31, true);


--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 296
-- Name: socios_id_socio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socios_id_socio_seq', 2, true);


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 285
-- Name: tipo_contribuyente_id_tipo_contribuyente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_contribuyente_id_tipo_contribuyente_seq', 11, true);


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 287
-- Name: tipo_pago_id_tipo_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_pago_id_tipo_pago_seq', 13, true);


--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 289
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 1, true);


--
-- TOC entry 3621 (class 2606 OID 18943)
-- Name: clientes cliente_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT cliente_email_key UNIQUE (email);


--
-- TOC entry 3623 (class 2606 OID 18945)
-- Name: clientes cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 3625 (class 2606 OID 18947)
-- Name: cupon cupon_codigo_unico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon
    ADD CONSTRAINT cupon_codigo_unico_key UNIQUE (codigo_unico);


--
-- TOC entry 3627 (class 2606 OID 18949)
-- Name: cupon cupon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon
    ADD CONSTRAINT cupon_pkey PRIMARY KEY (id_cupon);


--
-- TOC entry 3629 (class 2606 OID 18951)
-- Name: cupon_predefinido cupon_predefinido_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon_predefinido
    ADD CONSTRAINT cupon_predefinido_codigo_key UNIQUE (codigo);


--
-- TOC entry 3631 (class 2606 OID 18953)
-- Name: cupon_predefinido cupon_predefinido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon_predefinido
    ADD CONSTRAINT cupon_predefinido_pkey PRIMARY KEY (id_cupon_predefinido);


--
-- TOC entry 3669 (class 2606 OID 78833)
-- Name: cupones cupones_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_codigo_key UNIQUE (codigo);


--
-- TOC entry 3671 (class 2606 OID 78831)
-- Name: cupones cupones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_pkey PRIMARY KEY (id_cupon);


--
-- TOC entry 3633 (class 2606 OID 18955)
-- Name: estado_pedido estado_pedido_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_pedido
    ADD CONSTRAINT estado_pedido_nombre_key UNIQUE (nombre);


--
-- TOC entry 3635 (class 2606 OID 18957)
-- Name: estado_pedido estado_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_pedido
    ADD CONSTRAINT estado_pedido_pkey PRIMARY KEY (id_estado_pedido);


--
-- TOC entry 3637 (class 2606 OID 18959)
-- Name: ingredientes ingredientes_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_nombre_key UNIQUE (nombre);


--
-- TOC entry 3639 (class 2606 OID 18961)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id_ingrediente);


--
-- TOC entry 3645 (class 2606 OID 18963)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id_pedido);


--
-- TOC entry 3649 (class 2606 OID 18965)
-- Name: pedidos_productos_ingredientes pedidos_productos_ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos_ingredientes
    ADD CONSTRAINT pedidos_productos_ingredientes_pkey PRIMARY KEY (id_pedido_producto, id_ingrediente);


--
-- TOC entry 3647 (class 2606 OID 18967)
-- Name: pedidos_productos pedidos_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos
    ADD CONSTRAINT pedidos_productos_pkey PRIMARY KEY (id_pedido_producto);


--
-- TOC entry 3655 (class 2606 OID 18969)
-- Name: productos_ingredientes_base productos_ingredientes_base_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos_ingredientes_base
    ADD CONSTRAINT productos_ingredientes_base_pkey PRIMARY KEY (id_producto, id_ingrediente);


--
-- TOC entry 3651 (class 2606 OID 18971)
-- Name: productos productos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_nombre_key UNIQUE (nombre);


--
-- TOC entry 3653 (class 2606 OID 18973)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 3673 (class 2606 OID 84471)
-- Name: socios socios_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_dni_key UNIQUE (dni);


--
-- TOC entry 3675 (class 2606 OID 84469)
-- Name: socios socios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_pkey PRIMARY KEY (id_socio);


--
-- TOC entry 3657 (class 2606 OID 18975)
-- Name: tipo_contribuyente tipo_contribuyente_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente
    ADD CONSTRAINT tipo_contribuyente_nombre_key UNIQUE (nombre);


--
-- TOC entry 3659 (class 2606 OID 18977)
-- Name: tipo_contribuyente tipo_contribuyente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente
    ADD CONSTRAINT tipo_contribuyente_pkey PRIMARY KEY (id_tipo_contribuyente);


--
-- TOC entry 3661 (class 2606 OID 18979)
-- Name: tipo_pago tipo_pago_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT tipo_pago_nombre_key UNIQUE (nombre);


--
-- TOC entry 3663 (class 2606 OID 18981)
-- Name: tipo_pago tipo_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT tipo_pago_pkey PRIMARY KEY (id_tipo_pago);


--
-- TOC entry 3665 (class 2606 OID 18983)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 3667 (class 2606 OID 18985)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 3640 (class 1259 OID 18986)
-- Name: idx_pedidos_id_cliente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_id_cliente ON public.pedidos USING btree (id_cliente);


--
-- TOC entry 3641 (class 1259 OID 18987)
-- Name: idx_pedidos_id_cupon_aplicado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_id_cupon_aplicado ON public.pedidos USING btree (id_cupon_aplicado);


--
-- TOC entry 3642 (class 1259 OID 18988)
-- Name: idx_pedidos_id_estado_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_id_estado_pedido ON public.pedidos USING btree (id_estado_pedido);


--
-- TOC entry 3643 (class 1259 OID 18989)
-- Name: idx_pedidos_id_tipo_pago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_id_tipo_pago ON public.pedidos USING btree (id_tipo_pago);


--
-- TOC entry 3693 (class 2620 OID 18990)
-- Name: pedidos update_pedidos_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_pedidos_updated_at BEFORE UPDATE ON public.pedidos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 3676 (class 2606 OID 18991)
-- Name: clientes cliente_id_tipo_contribuyente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT cliente_id_tipo_contribuyente_fkey FOREIGN KEY (id_tipo_contribuyente) REFERENCES public.tipo_contribuyente(id_tipo_contribuyente);


--
-- TOC entry 3677 (class 2606 OID 18996)
-- Name: cupon cupon_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon
    ADD CONSTRAINT cupon_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);


--
-- TOC entry 3678 (class 2606 OID 19001)
-- Name: cupon cupon_id_cupon_predefinido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupon
    ADD CONSTRAINT cupon_id_cupon_predefinido_fkey FOREIGN KEY (id_cupon_predefinido) REFERENCES public.cupon_predefinido(id_cupon_predefinido);


--
-- TOC entry 3691 (class 2606 OID 78834)
-- Name: cupones cupones_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 3692 (class 2606 OID 78839)
-- Name: cupones cupones_id_pedido_usado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_id_pedido_usado_fkey FOREIGN KEY (id_pedido_usado) REFERENCES public.pedidos(id_pedido) ON DELETE SET NULL;


--
-- TOC entry 3679 (class 2606 OID 19006)
-- Name: pedidos fk_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);


--
-- TOC entry 3680 (class 2606 OID 19011)
-- Name: pedidos fk_cupon_aplicado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_cupon_aplicado FOREIGN KEY (id_cupon_aplicado) REFERENCES public.cupon(id_cupon);


--
-- TOC entry 3681 (class 2606 OID 19016)
-- Name: pedidos fk_estado_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_estado_pedido FOREIGN KEY (id_estado_pedido) REFERENCES public.estado_pedido(id_estado_pedido);


--
-- TOC entry 3682 (class 2606 OID 78845)
-- Name: pedidos fk_pedidos_cupon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_cupon FOREIGN KEY (id_cupon_usado) REFERENCES public.cupones(id_cupon) ON DELETE SET NULL;


--
-- TOC entry 3683 (class 2606 OID 84472)
-- Name: pedidos fk_pedidos_socios; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_socios FOREIGN KEY (id_socio) REFERENCES public.socios(id_socio) ON DELETE SET NULL;


--
-- TOC entry 3684 (class 2606 OID 19021)
-- Name: pedidos fk_tipo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_tipo_pago FOREIGN KEY (id_tipo_pago) REFERENCES public.tipo_pago(id_tipo_pago);


--
-- TOC entry 3685 (class 2606 OID 19026)
-- Name: pedidos_productos pedidos_productos_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos
    ADD CONSTRAINT pedidos_productos_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- TOC entry 3686 (class 2606 OID 19031)
-- Name: pedidos_productos_ingredientes pedidos_productos_ingredientes_id_ingrediente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos_ingredientes
    ADD CONSTRAINT pedidos_productos_ingredientes_id_ingrediente_fkey FOREIGN KEY (id_ingrediente) REFERENCES public.ingredientes(id_ingrediente);


--
-- TOC entry 3687 (class 2606 OID 19036)
-- Name: pedidos_productos_ingredientes pedidos_productos_ingredientes_id_pedido_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos_productos_ingredientes
    ADD CONSTRAINT pedidos_productos_ingredientes_id_pedido_producto_fkey FOREIGN KEY (id_pedido_producto) REFERENCES public.pedidos_productos(id_pedido_producto);


--
-- TOC entry 3688 (class 2606 OID 19041)
-- Name: productos_ingredientes_base productos_ingredientes_base_id_ingrediente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos_ingredientes_base
    ADD CONSTRAINT productos_ingredientes_base_id_ingrediente_fkey FOREIGN KEY (id_ingrediente) REFERENCES public.ingredientes(id_ingrediente);


--
-- TOC entry 3689 (class 2606 OID 19046)
-- Name: productos_ingredientes_base productos_ingredientes_base_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos_ingredientes_base
    ADD CONSTRAINT productos_ingredientes_base_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- TOC entry 3690 (class 2606 OID 19051)
-- Name: usuarios usuarios_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 402
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE clientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.clientes TO anon;
GRANT ALL ON TABLE public.clientes TO authenticated;
GRANT ALL ON TABLE public.clientes TO service_role;


--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE cliente_id_cliente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cliente_id_cliente_seq TO anon;
GRANT ALL ON SEQUENCE public.cliente_id_cliente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.cliente_id_cliente_seq TO service_role;


--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE cupon; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cupon TO anon;
GRANT ALL ON TABLE public.cupon TO authenticated;
GRANT ALL ON TABLE public.cupon TO service_role;


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE cupon_id_cupon_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cupon_id_cupon_seq TO anon;
GRANT ALL ON SEQUENCE public.cupon_id_cupon_seq TO authenticated;
GRANT ALL ON SEQUENCE public.cupon_id_cupon_seq TO service_role;


--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE cupon_predefinido; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cupon_predefinido TO anon;
GRANT ALL ON TABLE public.cupon_predefinido TO authenticated;
GRANT ALL ON TABLE public.cupon_predefinido TO service_role;


--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE cupon_predefinido_id_cupon_predefinido_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq TO anon;
GRANT ALL ON SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq TO authenticated;
GRANT ALL ON SEQUENCE public.cupon_predefinido_id_cupon_predefinido_seq TO service_role;


--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE cupones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cupones TO anon;
GRANT ALL ON TABLE public.cupones TO authenticated;
GRANT ALL ON TABLE public.cupones TO service_role;


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE estado_pedido; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.estado_pedido TO anon;
GRANT ALL ON TABLE public.estado_pedido TO authenticated;
GRANT ALL ON TABLE public.estado_pedido TO service_role;


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 273
-- Name: SEQUENCE estado_pedido_id_estado_pedido_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.estado_pedido_id_estado_pedido_seq TO anon;
GRANT ALL ON SEQUENCE public.estado_pedido_id_estado_pedido_seq TO authenticated;
GRANT ALL ON SEQUENCE public.estado_pedido_id_estado_pedido_seq TO service_role;


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE ingredientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ingredientes TO anon;
GRANT ALL ON TABLE public.ingredientes TO authenticated;
GRANT ALL ON TABLE public.ingredientes TO service_role;


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 275
-- Name: SEQUENCE ingredientes_id_ingrediente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO anon;
GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO service_role;


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE pedidos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pedidos TO anon;
GRANT ALL ON TABLE public.pedidos TO authenticated;
GRANT ALL ON TABLE public.pedidos TO service_role;


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 277
-- Name: SEQUENCE pedidos_id_pedido_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pedidos_id_pedido_seq TO anon;
GRANT ALL ON SEQUENCE public.pedidos_id_pedido_seq TO authenticated;
GRANT ALL ON SEQUENCE public.pedidos_id_pedido_seq TO service_role;


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE pedidos_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pedidos_productos TO anon;
GRANT ALL ON TABLE public.pedidos_productos TO authenticated;
GRANT ALL ON TABLE public.pedidos_productos TO service_role;


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 279
-- Name: SEQUENCE pedidos_productos_id_pedido_producto_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pedidos_productos_id_pedido_producto_seq TO anon;
GRANT ALL ON SEQUENCE public.pedidos_productos_id_pedido_producto_seq TO authenticated;
GRANT ALL ON SEQUENCE public.pedidos_productos_id_pedido_producto_seq TO service_role;


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE pedidos_productos_ingredientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pedidos_productos_ingredientes TO anon;
GRANT ALL ON TABLE public.pedidos_productos_ingredientes TO authenticated;
GRANT ALL ON TABLE public.pedidos_productos_ingredientes TO service_role;


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.productos TO anon;
GRANT ALL ON TABLE public.productos TO authenticated;
GRANT ALL ON TABLE public.productos TO service_role;


--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE productos_id_producto_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO anon;
GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO authenticated;
GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO service_role;


--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE productos_ingredientes_base; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.productos_ingredientes_base TO anon;
GRANT ALL ON TABLE public.productos_ingredientes_base TO authenticated;
GRANT ALL ON TABLE public.productos_ingredientes_base TO service_role;


--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE socios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.socios TO anon;
GRANT ALL ON TABLE public.socios TO authenticated;
GRANT ALL ON TABLE public.socios TO service_role;


--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 296
-- Name: SEQUENCE socios_id_socio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.socios_id_socio_seq TO anon;
GRANT ALL ON SEQUENCE public.socios_id_socio_seq TO authenticated;
GRANT ALL ON SEQUENCE public.socios_id_socio_seq TO service_role;


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE tipo_contribuyente; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipo_contribuyente TO anon;
GRANT ALL ON TABLE public.tipo_contribuyente TO authenticated;
GRANT ALL ON TABLE public.tipo_contribuyente TO service_role;


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 285
-- Name: SEQUENCE tipo_contribuyente_id_tipo_contribuyente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq TO anon;
GRANT ALL ON SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.tipo_contribuyente_id_tipo_contribuyente_seq TO service_role;


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE tipo_pago; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipo_pago TO anon;
GRANT ALL ON TABLE public.tipo_pago TO authenticated;
GRANT ALL ON TABLE public.tipo_pago TO service_role;


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 287
-- Name: SEQUENCE tipo_pago_id_tipo_pago_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tipo_pago_id_tipo_pago_seq TO anon;
GRANT ALL ON SEQUENCE public.tipo_pago_id_tipo_pago_seq TO authenticated;
GRANT ALL ON SEQUENCE public.tipo_pago_id_tipo_pago_seq TO service_role;


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO anon;
GRANT ALL ON TABLE public.usuarios TO authenticated;
GRANT ALL ON TABLE public.usuarios TO service_role;


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 289
-- Name: SEQUENCE usuarios_id_usuario_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO anon;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO authenticated;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO service_role;


--
-- TOC entry 2377 (class 826 OID 16490)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2378 (class 826 OID 16491)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2376 (class 826 OID 16489)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2380 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2375 (class 826 OID 16488)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2379 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


-- Completed on 2025-10-20 16:41:39

--
-- PostgreSQL database dump complete
--

\unrestrict Asv0pRB9l7tplkYMETg6HdXgqtvHrxBRw9ABh7oVNXyYQxsiW068W2ACWI4DzY0

