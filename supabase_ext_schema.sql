-- Executar no SQL Editor do Supabase (após supabase_ka_schema.sql)

-- Lojas pré-cadastradas por cliente (visitas KA)
CREATE TABLE IF NOT EXISTS lojas_ka (
  id BIGSERIAL PRIMARY KEY,
  cliente TEXT NOT NULL,
  nome TEXT NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_lojas_ka_cliente ON lojas_ka(cliente);

-- Distribuidores de retalho (preços Delta / revenda / ponta)
CREATE TABLE IF NOT EXISTS clientes_dist_retalho (
  id BIGSERIAL PRIMARY KEY,
  distribuidor TEXT NOT NULL,
  margem_id BIGINT NOT NULL,
  preco_delta NUMERIC,
  preco_revenda NUMERIC,
  preco_ponta NUMERIC,
  cx_unid INTEGER,
  activo BOOLEAN DEFAULT TRUE,
  status TEXT DEFAULT 'Disponivel',
  notas TEXT
);
CREATE INDEX IF NOT EXISTS idx_cdr_distribuidor ON clientes_dist_retalho(distribuidor);
CREATE INDEX IF NOT EXISTS idx_cdr_margem ON clientes_dist_retalho(margem_id);

ALTER TABLE lojas_ka ENABLE ROW LEVEL SECURITY;
ALTER TABLE clientes_dist_retalho ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all lojas_ka" ON lojas_ka;
DROP POLICY IF EXISTS "anon_all clientes_dist_retalho" ON clientes_dist_retalho;

CREATE POLICY "anon_all lojas_ka" ON lojas_ka FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all clientes_dist_retalho" ON clientes_dist_retalho FOR ALL TO anon USING (true) WITH CHECK (true);

-- Preços base por distribuidor (secção Preços Base em Dist. Retalho)
ALTER TABLE clientes_dist_retalho ADD COLUMN IF NOT EXISTS preco_bruto NUMERIC;
ALTER TABLE clientes_dist_retalho ADD COLUMN IF NOT EXISTS preco_liq NUMERIC;
ALTER TABLE clientes_dist_retalho ADD COLUMN IF NOT EXISTS desc_base NUMERIC;

-- Cliente final (PVP e promo por distribuidor)
ALTER TABLE clientes_dist_retalho ADD COLUMN IF NOT EXISTS pvp_rec NUMERIC;
ALTER TABLE clientes_dist_retalho ADD COLUMN IF NOT EXISTS pvp_de_por NUMERIC;

-- Clientes por canal (Horeca / Distribuidores)
CREATE TABLE IF NOT EXISTS clientes_canal (
  id BIGSERIAL PRIMARY KEY,
  canal TEXT NOT NULL CHECK (canal IN ('horeca','dist')),
  cliente TEXT NOT NULL,
  margem_id BIGINT NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  preco_liq NUMERIC,
  preco_bruto NUMERIC,
  desc_pct NUMERIC,
  pvp_rec NUMERIC,
  notas TEXT
);
CREATE INDEX IF NOT EXISTS idx_cc_canal ON clientes_canal(canal);
CREATE INDEX IF NOT EXISTS idx_cc_cliente ON clientes_canal(cliente);
CREATE INDEX IF NOT EXISTS idx_cc_margem ON clientes_canal(margem_id);

ALTER TABLE clientes_canal ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all clientes_canal" ON clientes_canal;
CREATE POLICY "anon_all clientes_canal" ON clientes_canal FOR ALL TO anon USING (true) WITH CHECK (true);

-- Preços por cliente retalho (opcional — alinha com a app)
ALTER TABLE clientes_retalho ADD COLUMN IF NOT EXISTS preco_liq NUMERIC;
ALTER TABLE clientes_retalho ADD COLUMN IF NOT EXISTS preco_bruto NUMERIC;
