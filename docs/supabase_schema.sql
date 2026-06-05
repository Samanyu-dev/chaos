-- Supabase Database Schema for Orbit (Chaos)
-- Enable PostGIS extension for geolocated queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Profiles Table (extending auth.users)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    avatar VARCHAR(10) NOT NULL DEFAULT '👤',
    status VARCHAR(255) NOT NULL DEFAULT '',
    active_emoji VARCHAR(10) NOT NULL DEFAULT '',
    lat_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    lon_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
CREATE POLICY "Users can read all profiles." ON public.profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile." ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- 2. Trips Table
CREATE TABLE public.trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(150) NOT NULL,
    subtitle VARCHAR(255) NOT NULL DEFAULT '',
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    cost NUMERIC(10, 2) NOT NULL DEFAULT 0.0,
    banner_colors TEXT[] NOT NULL DEFAULT ARRAY['#3a86ff', '#8338ec'], -- HEX color strings
    days_left INT NOT NULL DEFAULT 0,
    created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on Trips
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;

-- 3. Trip Members (mapping table)
CREATE TABLE public.trip_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (trip_id, profile_id)
);

-- Enable RLS on Trip Members
ALTER TABLE public.trip_members ENABLE ROW LEVEL SECURITY;

-- Trip & Member Policies (Users can only read/edit trips they belong to)
CREATE POLICY "Users can view trips they are a member of." ON public.trips
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = trips.id AND trip_members.profile_id = auth.uid()
        )
    );

CREATE POLICY "Trip owners can insert trips." ON public.trips
    FOR INSERT WITH CHECK (created_by = auth.uid());

CREATE POLICY "Members can view trip mappings." ON public.trip_members
    FOR SELECT USING (
        profile_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.trip_members tm
            WHERE tm.trip_id = trip_members.trip_id AND tm.profile_id = auth.uid()
        )
    );

CREATE POLICY "Members can insert invitations." ON public.trip_members
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = trip_members.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

-- 4. Itinerary Items
CREATE TABLE public.itinerary_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE,
    time_label VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    details TEXT NOT NULL DEFAULT '',
    emoji VARCHAR(10) NOT NULL DEFAULT '📍',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.itinerary_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view itineraries." ON public.itinerary_items
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = itinerary_items.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

-- 5. Memories Table
CREATE TABLE public.memories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_avatar VARCHAR(10) NOT NULL DEFAULT '👤',
    caption TEXT NOT NULL DEFAULT '',
    relative_time VARCHAR(50) NOT NULL DEFAULT 'Just now',
    likes INT NOT NULL DEFAULT 0,
    perspective_name VARCHAR(100) NOT NULL DEFAULT 'My Perspective',
    gradient_colors TEXT[] NOT NULL DEFAULT ARRAY['#ff007f', '#7000ff'],
    image_url TEXT,
    lat_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    lon_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.memories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view memories." ON public.memories
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = memories.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

CREATE POLICY "Members can insert memories." ON public.memories
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = memories.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

-- 6. Expenses Table
CREATE TABLE public.expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payer_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    category VARCHAR(50) NOT NULL DEFAULT 'General',
    lat_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    lon_offset DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view expenses." ON public.expenses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = expenses.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

CREATE POLICY "Members can log expenses." ON public.expenses
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.trip_members
            WHERE trip_members.trip_id = expenses.trip_id AND trip_members.profile_id = auth.uid()
        )
    );

-- 7. Expense Splits Table
CREATE TABLE public.expense_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID REFERENCES public.expenses(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount NUMERIC(10, 2) NOT NULL,
    is_settled BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (expense_id, profile_id)
);

ALTER TABLE public.expense_splits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view expense splits." ON public.expense_splits
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.expenses e
            JOIN public.trip_members tm ON tm.trip_id = e.trip_id
            WHERE e.id = expense_splits.expense_id AND tm.profile_id = auth.uid()
        )
    );

CREATE POLICY "Members can write expense splits." ON public.expense_splits
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.expenses e
            JOIN public.trip_members tm ON tm.trip_id = e.trip_id
            WHERE e.id = expense_splits.expense_id AND tm.profile_id = auth.uid()
        )
    );
