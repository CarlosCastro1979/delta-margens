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
