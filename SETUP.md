# Signups

Signups go straight into Supabase. Nothing to set up — it's already wired and tested.

| | |
|---|---|
| Project | **sauna-race** (`khqxsemkfoyuhzwfavdt`), region `eu-north-1` (Stockholm) |
| Org | hekevinb-gmailcom's projects |
| Table | `public.signups` |
| Dashboard | https://supabase.com/dashboard/project/khqxsemkfoyuhzwfavdt/editor |

## Seeing who signed up

Easiest is the table editor link above. From the terminal:

```sh
SECRET=$(supabase projects api-keys --project-ref khqxsemkfoyuhzwfavdt \
          --output json --reveal \
          | python3 -c "import json,sys;[print(k['api_key']) for k in json.load(sys.stdin) if k['api_key'].startswith('sb_secret_')]")

curl -s "https://khqxsemkfoyuhzwfavdt.supabase.co/rest/v1/signups?select=*&order=created_at" \
     -H "apikey: $SECRET" -H "Authorization: Bearer $SECRET" | python3 -m json.tool
```

## How it's wired

`index.html` posts to the PostgREST endpoint with the **publishable** key. That key is
public on purpose — it's in a public repo and visible in the page source, which is fine:

- Row level security is on, and the only policy is `insert` for `anon`.
- There is no select/update/delete policy, so that key can add a signup but
  **cannot read the list back, edit it, or delete it.** Verified: a `select` with the
  publishable key returns `[]` even when rows exist.
- The insert policy also validates on the server — name 1-100 chars, a real-looking
  email, phone 5-40 chars — so the checks aren't only in the browser.

Reading requires the **secret** key, which is not in this repo.

## Changing the table

Migrations live in `supabase/migrations/`. After editing:

```sh
supabase db push
```

## Local backup

The page also stashes each signup in the visitor's own `localStorage` before posting.
That's a belt-and-braces thing for network hiccups, not something you can read.
