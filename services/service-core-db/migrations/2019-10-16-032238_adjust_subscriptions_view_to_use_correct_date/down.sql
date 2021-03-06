-- This file should undo anything in `up.sql`
CREATE OR REPLACE VIEW "analytics_service_api"."project_subscriptions_per_day" AS 
 SELECT i.project_id,
    json_agg(json_build_object('paid_at', i.paid_at, 'created_at', i.created_at, 'total', i.total, 'total_amount', i.total_amount)) AS source
   FROM ( SELECT s.project_id,
            date_trunc('day'::text, s.created_at) AS created_at,
            count(s.*) AS total,
            date_trunc('day'::text, payment_service.paid_transition_at(cp.*)) AS paid_at,
            (sum(((cp.data ->> 'amount'::text))::numeric) / (100)::numeric) AS total_amount
           FROM ((payment_service.subscriptions s
             JOIN project_service.projects p ON ((p.id = s.project_id)))
             JOIN payment_service.catalog_payments cp ON ((cp.subscription_id = s.id)))
          WHERE ((s.created_at >= (now() - '30 days'::interval)) AND (cp.status = 'paid'::payment_service.payment_status) AND ((s.status = 'active'::payment_service.subscription_status) AND (s.platform_id = core.current_platform_id()) AND (core.is_owner_or_admin(s.user_id) OR core.is_owner_or_admin(p.user_id))))
          GROUP BY s.project_id, (date_trunc('day'::text, s.created_at)), (date_trunc('day'::text, payment_service.paid_transition_at(cp.*)))) i
  GROUP BY i.project_id;

CREATE OR REPLACE VIEW "payment_service_api"."subscriptions_per_month" AS 
 SELECT s.project_id,
    count(DISTINCT s.id) AS total_subscriptions,
    COALESCE(sum(((cp.data ->> 'amount'::text))::numeric), (0)::numeric) AS total_amount,
    count(DISTINCT s.id) FILTER (WHERE (NOT (EXISTS ( SELECT true AS bool
           FROM payment_service.catalog_payments past_payments
          WHERE ((past_payments.subscription_id = s.id) AND (past_payments.status = 'paid'::payment_service.payment_status) AND ((cp.data ->> 'payment_method'::text) = (past_payments.data ->> 'payment_method'::text)) AND (past_payments.id <> cp.id) AND (past_payments.created_at < cp.created_at)))))) AS new_subscriptions,
    COALESCE(sum(((cp.data ->> 'amount'::text))::numeric) FILTER (WHERE (NOT (EXISTS ( SELECT true AS bool
           FROM payment_service.catalog_payments past_payments
          WHERE ((past_payments.subscription_id = s.id) AND (past_payments.status = 'paid'::payment_service.payment_status) AND ((cp.data ->> 'payment_method'::text) = (past_payments.data ->> 'payment_method'::text)) AND (past_payments.id <> cp.id) AND (past_payments.created_at < cp.created_at)))))), (0)::numeric) AS new_amount,
    p.external_id AS project_external_id,
    (cp.data ->> 'payment_method'::text) AS payment_method,
    (date_trunc('month'::text, payment_service.paid_transition_at(cp.*)))::date AS month
   FROM ((payment_service.catalog_payments cp
     JOIN payment_service.subscriptions s ON ((cp.subscription_id = s.id)))
     JOIN project_service.projects p ON ((p.id = s.project_id)))
  WHERE ((cp.status = 'paid'::payment_service.payment_status) AND ((s.status <> 'deleted'::payment_service.subscription_status) AND (s.platform_id = core.current_platform_id()) AND (core.is_owner_or_admin(s.user_id) OR core.is_owner_or_admin(p.user_id))))
  GROUP BY ((date_trunc('month'::text, payment_service.paid_transition_at(cp.*)))::date), s.project_id, p.external_id, (cp.data ->> 'payment_method'::text);

DROP FUNCTION payment_service.get_first_paid_payment(subscription_id uuid);
