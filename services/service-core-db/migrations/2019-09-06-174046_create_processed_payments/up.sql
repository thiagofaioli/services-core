-- Your SQL goes here
CREATE TABLE payment_service.processed_payments (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL PRIMARY KEY,
	catalog_payment_id uuid NOT NULL REFERENCES payment_service.catalog_payments(id),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE UNIQUE INDEX processed_payments_catalog_payment_id_idx ON payment_service.processed_payments (catalog_payment_id);
COMMENT ON TABLE payment_service.processed_payments IS 'store processed catalog payments';
