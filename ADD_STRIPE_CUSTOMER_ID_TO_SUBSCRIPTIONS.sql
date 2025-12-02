-- =====================================================
-- Migration: Add stripe_customer_id to subscriptions table
-- =====================================================
-- This adds the missing stripe_customer_id field to the subscriptions table
-- Run this if your production database doesn't have this field

-- Add the column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'subscriptions' 
        AND column_name = 'stripe_customer_id'
    ) THEN
        ALTER TABLE public.subscriptions 
        ADD COLUMN stripe_customer_id TEXT;
        
        -- Add an index for faster lookups
        CREATE INDEX IF NOT EXISTS idx_subscriptions_stripe_customer_id 
        ON public.subscriptions(stripe_customer_id);
        
        RAISE NOTICE 'Added stripe_customer_id column to subscriptions table';
    ELSE
        RAISE NOTICE 'Column stripe_customer_id already exists';
    END IF;
END $$;

-- =====================================================
-- End of migration
-- =====================================================

