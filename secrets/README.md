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
scripts/secret-encrypt.sh CLAUDE_CODE_OAUTH_TOKEN
```

The security of this rests entirely on the passcode, because the ciphertext is public.
600k PBKDF2 iterations make a strong passphrase infeasible to attack offline and do
nothing to save a weak one. Use four or five random words: easy to say to a room, far
beyond brute force. Do not use the course name, the date, or anything guessable.

Revoke the underlying credential after the session.
