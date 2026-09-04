-- Migración: Creación de tabla study_reviews y configuración de políticas RLS
-- Idempotente según estándar del proyecto y .agents/rules/database.md

CREATE TABLE IF NOT EXISTS public.study_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    card_id TEXT NOT NULL,
    rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 4),
    recall_answer TEXT,
    interval_days INTEGER NOT NULL DEFAULT 1,
    ease_factor NUMERIC(4,2) NOT NULL DEFAULT 2.50,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Habilitar Row Level Security (Mandatorio por regla database.md)
ALTER TABLE public.study_reviews ENABLE ROW LEVEL SECURITY;

-- Políticas de Seguridad RLS idempotentes
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'study_reviews' AND policyname = 'Users can view their own reviews'
    ) THEN
        CREATE POLICY "Users can view their own reviews"
            ON public.study_reviews
            FOR SELECT
            USING (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'study_reviews' AND policyname = 'Users can insert their own reviews'
    ) THEN
        CREATE POLICY "Users can insert their own reviews"
            ON public.study_reviews
            FOR INSERT
            WITH CHECK (auth.uid() = user_id);
    END IF;
END
$$;

-- Índices de consulta eficiente
CREATE INDEX IF NOT EXISTS idx_study_reviews_user_card 
    ON public.study_reviews(user_id, card_id);

CREATE INDEX IF NOT EXISTS idx_study_reviews_created_at 
    ON public.study_reviews(created_at DESC);
