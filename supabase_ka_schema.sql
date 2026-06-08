-- Executar no SQL Editor do Supabase (projeto qnscwppgljobelplgbkp)
-- Tabelas para recolha de preços e ruturas em loja (KA Retalho)

CREATE TABLE IF NOT EXISTS visitas_ka (
  id BIGSERIAL PRIMARY KEY,
  cliente TEXT NOT NULL,
  loja TEXT,
  rep_nome TEXT,
  notas TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS visitas_ka_itens (
  id BIGSERIAL PRIMARY KEY,
  visita_id BIGINT NOT NULL REFERENCES visitas_ka(id) ON DELETE CASCADE,
  margem_id BIGINT NOT NULL,
  preco_gondola NUMERIC,
  preco_promo NUMERIC,
  rutura BOOLEAN DEFAULT FALSE,
  observacao TEXT
);

CREATE TABLE IF NOT EXISTS visitas_ka_fotos (
  id BIGSERIAL PRIMARY KEY,
  visita_id BIGINT NOT NULL REFERENCES visitas_ka(id) ON DELETE CASCADE,
  tipo TEXT NOT NULL CHECK (tipo IN ('linear', 'extra')),
  foto_data TEXT,
  descricao TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_visitas_ka_cliente ON visitas_ka(cliente);
CREATE INDEX IF NOT EXISTS idx_visitas_ka_itens_visita ON visitas_ka_itens(visita_id);
CREATE INDEX IF NOT EXISTS idx_visitas_ka_fotos_visita ON visitas_ka_fotos(visita_id);

ALTER TABLE visitas_ka ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitas_ka_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitas_ka_fotos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all visitas_ka" ON visitas_ka;
DROP POLICY IF EXISTS "anon_all visitas_ka_itens" ON visitas_ka_itens;
DROP POLICY IF EXISTS "anon_all visitas_ka_fotos" ON visitas_ka_fotos;

CREATE POLICY "anon_all visitas_ka" ON visitas_ka FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all visitas_ka_itens" ON visitas_ka_itens FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all visitas_ka_fotos" ON visitas_ka_fotos FOR ALL TO anon USING (true) WITH CHECK (true);
