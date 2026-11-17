-- Migrasi 001: Inisialisasi Tabel Kos dan Kebijakan Row Level Security (RLS)
-- Proyek: KosFinder

-- 1. Pembuatan Tabel kos
CREATE TABLE IF NOT EXISTS public.kos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    area TEXT NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0),
    facilities TEXT[] NOT NULL DEFAULT '{}',
    contact TEXT NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indeks untuk meningkatkan performa kueri
CREATE INDEX IF NOT EXISTS idx_kos_owner_id ON public.kos (owner_id);
CREATE INDEX IF NOT EXISTS idx_kos_area ON public.kos (area);
CREATE INDEX IF NOT EXISTS idx_kos_price ON public.kos (price);

-- 2. Aktifkan Row Level Security (RLS)
ALTER TABLE public.kos ENABLE ROW LEVEL SECURITY;

-- 3. Kebijakan RLS (Security Policies)

-- A. SELECT: Terbuka untuk umum (siapa saja boleh melihat kos yang terdaftar)
CREATE POLICY "Public read access for all kos"
ON public.kos
FOR SELECT
USING (true);

-- B. INSERT: Hanya pemilik akun yang sudah terotentikasi yang dapat menambahkan kos miliknya sendiri
CREATE POLICY "Authenticated owners can insert their own kos"
ON public.kos
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = owner_id);

-- C. UPDATE: Hanya pemilik kos bersangkutan yang dapat mengubah datanya
CREATE POLICY "Owners can update their own kos"
ON public.kos
FOR UPDATE
TO authenticated
USING (auth.uid() = owner_id)
WITH CHECK (auth.uid() = owner_id);

-- D. DELETE: Hanya pemilik kos bersangkutan yang dapat menghapus datanya
CREATE POLICY "Owners can delete their own kos"
ON public.kos
FOR DELETE
TO authenticated
USING (auth.uid() = owner_id);
