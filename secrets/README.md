# secrets/

Encrypted credentials only. **Nothing in plaintext ever lands here**, and `.gitignore` is
written to block everything in this directory except `*.enc` and this README.

Each `*.enc` is one environment variable, encrypted under a passcode the instructor says
aloud in the room:

- AES-256-CBC, PBKDF2-SHA256 at 600,000 iterations, random salt, base64 armored.
- The filename is the variable name students receive. `CLAUDE_CODE_OAUTH_TOKEN.enc`
  unlocks to `$CLAUDE_CODE_OAUTH_TOKEN`.

**Unlock (students):**

```bash
source scripts/claude-login.sh
```

**Create or rotate (instructor):**

```bash
claude setup-token
```

That mints a long-lived OAuth token, valid about a year, and prints it once. Then:

```bash
scripts/secret-encrypt.sh CLAUDE_CODE_OAUTH_TOKEN
```

Paste the token at the hidden prompt and type the passcode twice. It writes only the `.enc`.
The script never prints the secret, never writes plaintext to disk, and never puts the secret
or the passcode on a command line where `ps` could see it.

**Never let the plaintext token touch anything but that hidden prompt.** Not a chat window, not
a notebook cell, not a commit message. If it lands somewhere it should not, mint a fresh one
and confirm the old one is dead.

The security of this rests entirely on the passcode, because the ciphertext is public.
600k PBKDF2 iterations make a strong passphrase infeasible to attack offline and do
nothing to save a weak one. Use four or five random words: easy to say to a room, far
beyond brute force. Do not use the course name, the date, or anything guessable.

**Revoke the underlying credential the same day the session ends.** Anything students kept then
stops working, and the ciphertext sitting in this public repo becomes worthless. Verify the
revocation actually took effect in your account settings rather than assuming that re-minting a
token invalidates the old one.
