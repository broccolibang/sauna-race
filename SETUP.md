# Connecting the signup form to your Google Sheet

Your sheet is already made and already has the header row:
**Sauna Race Signups** — https://docs.google.com/spreadsheets/d/1squvne685dwjdVNDUyh_M5CScddaoC49bvxerZKKvio/edit

This part has to be done in the browser (Google won't let a script deploy itself). Takes about 2 minutes.

## 1. Open the script editor
In the sheet: **Extensions → Apps Script**. Delete whatever code is in the editor.

## 2. Paste this in

```javascript
function doPost(e) {
  var lock = LockService.getScriptLock();
  lock.waitLock(20000);
  try {
    var d = JSON.parse(e.postData.contents);
    SpreadsheetApp.getActiveSpreadsheet()
      .getSheets()[0]
      .appendRow([
        new Date(),
        d.name  || '',
        d.email || '',
        d.phone || '',
        d.ready ? 'YES' : 'no'
      ]);
    return ContentService
      .createTextOutput(JSON.stringify({ok: true}))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ok: false, error: String(err)}))
      .setMimeType(ContentService.MimeType.JSON);
  } finally {
    lock.releaseLock();
  }
}
```

Hit the save icon.

## 3. Deploy it
**Deploy → New deployment** → click the gear next to "Select type" → **Web app**.

Set these two exactly:
- **Execute as:** Me
- **Who has access:** **Anyone**  ← this one matters, "Anyone with Google account" will silently reject signups

Click **Deploy**, then **Authorize access**. Google will warn you the app isn't verified: click
**Advanced → Go to (project name)** and allow it. That warning is expected, it's your own script.

## 4. Copy the URL
You'll get a **Web app URL** ending in `/exec`. Copy it.

## 5. Give it to me
Paste it into the chat and I'll drop it into the site and redeploy. Or do it yourself:
open `index.html`, find `const FORM_ENDPOINT = "";` near the bottom, and put the URL between the quotes.

## Testing it
Submit the form once. A row should appear in the sheet within a couple seconds.
If nothing shows up, the usual cause is step 3's "Who has access" not being set to **Anyone**.
