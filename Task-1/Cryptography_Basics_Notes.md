# Cryptography Basics — Study Notes

---

## 1. Symmetric vs Asymmetric Encryption

Encryption transforms readable data (**plaintext**) into unreadable data (**ciphertext**) to protect confidentiality. There are two main approaches.

### Symmetric Encryption
- Uses **one single key** for both encryption and decryption.
- **Fast and efficient** — ideal for encrypting large amounts of data.
- **Challenge:** the key must be securely shared between sender and receiver ("key distribution problem").
- **Common algorithms:** AES (Advanced Encryption Standard), DES, 3DES, Blowfish.
- **Analogy:** A single physical key that both locks and unlocks the same door.

### Asymmetric Encryption
- Uses a **key pair**: a **public key** (shared openly) and a **private key** (kept secret).
- Data encrypted with the public key can only be decrypted with the matching private key (and vice versa for digital signatures).
- **Slower** than symmetric encryption but solves the key distribution problem.
- **Common algorithms:** RSA, ECC (Elliptic Curve Cryptography), Diffie-Hellman.
- **Analogy:** A mailbox with a public slot anyone can drop mail into, but only the owner has the key to open it.

### Comparison Table

| Feature | Symmetric | Asymmetric |
|---|---|---|
| Keys used | One shared key | Public + private key pair |
| Speed | Fast | Slower |
| Key distribution | Difficult (must stay secret) | Easier (public key can be shared openly) |
| Common use | Bulk data encryption | Key exchange, digital signatures, authentication |
| Examples | AES, DES, 3DES | RSA, ECC, Diffie-Hellman |

> **In practice:** Most real-world systems (like HTTPS) use **both** — asymmetric encryption to securely exchange a symmetric key, then symmetric encryption for the actual data transfer (this is called a **hybrid cryptosystem**).

---

## 2. Hashing (MD5, SHA-256)

### What is Hashing?
- A **one-way function** that converts input data of any size into a fixed-length string (the "hash" or "digest").
- **Not encryption** — hashes cannot be reversed back into the original data.
- Used to verify **integrity**, not confidentiality.

### Key Properties of a Good Hash Function
- **Deterministic:** same input always produces the same output.
- **Fast to compute.**
- **Pre-image resistant:** can't reverse-engineer the input from the hash.
- **Collision resistant:** extremely unlikely for two different inputs to produce the same hash.
- **Avalanche effect:** a tiny change in input drastically changes the output hash.

### Common Hash Algorithms

| Algorithm | Output Size | Status |
|---|---|---|
| **MD5** | 128-bit | **Broken/insecure** — vulnerable to collisions, should not be used for security purposes (still used for basic checksums) |
| **SHA-1** | 160-bit | **Deprecated** — collision attacks demonstrated |
| **SHA-256** | 256-bit | **Currently secure and widely used** (part of the SHA-2 family) |
| **SHA-3** | Variable | Newer standard, different internal design than SHA-2 |
| **bcrypt / Argon2** | Variable | Purpose-built for **password hashing** (slow by design to resist brute force) |

### Common Uses of Hashing
- Verifying file integrity (checksums for downloads).
- Storing passwords securely (never store plaintext passwords — store salted hashes).
- Digital signatures (hash the message, then sign the hash).
- Blockchain and data structures (e.g., Git commit hashes).

> **Important distinction:** Hashing ≠ Encryption. Hashing is **one-way** (for integrity/verification); encryption is **two-way** (for confidentiality, requires a key to reverse).

---

## 3. Digital Certificates & SSL/TLS

### Digital Certificates
- An electronic document that binds a **public key** to an identity (person, organization, or website), issued and signed by a trusted **Certificate Authority (CA)**.
- Follows the **X.509 standard**.
- **Contains:** subject identity, public key, issuer (CA), validity period, digital signature of the CA.

### Certificate Authorities (CAs)
- Trusted third parties that verify identity and issue certificates (e.g., DigiCert, Let's Encrypt, Sectigo).
- Browsers/OSs maintain a built-in list of trusted **root CAs**.
- Forms a **chain of trust**: Root CA → Intermediate CA → End-entity (website) certificate.

### SSL/TLS
- **SSL (Secure Sockets Layer)** is the older protocol; **TLS (Transport Layer Security)** is its modern successor. "SSL" is still used colloquially, but TLS is what's actually in use today.
- Provides **confidentiality, integrity, and authentication** for data in transit.

### The TLS Handshake (Simplified)
1. **Client Hello:** Client sends supported TLS versions and cipher suites.
2. **Server Hello:** Server responds with chosen cipher suite and its digital certificate (containing its public key).
3. **Certificate Verification:** Client verifies the certificate against trusted CAs.
4. **Key Exchange:** Client and server generate/exchange a shared **session key** (often using Diffie-Hellman), enabling symmetric encryption for the session.
5. **Secure Communication Begins:** All further data is encrypted using the fast symmetric session key.

> This handshake is a real-world example of the **hybrid cryptosystem** mentioned earlier — asymmetric crypto to establish trust and exchange keys, symmetric crypto for the actual data.

### Quick Facts
- HTTPS = HTTP + TLS, uses **port 443**.
- A padlock icon in the browser indicates a valid TLS certificate — it confirms encryption and identity verification, **not** that a site is trustworthy/safe in content.
- **Certificate pinning** and **HSTS (HTTP Strict Transport Security)** are additional protections against certificate-based attacks.

---

## 4. Hands-On: Encrypt and Decrypt Messages Using OpenSSL

**OpenSSL** is a widely used command-line toolkit for cryptographic operations, available on most Linux distributions (including Kali).

### Symmetric Encryption Example (AES-256)

**Encrypt a file:**
```
openssl enc -aes-256-cbc -salt -in message.txt -out message.enc -pbkdf2
```
- `-aes-256-cbc` — algorithm and mode
- `-salt` — adds randomness to prevent identical outputs for identical inputs
- `-pbkdf2` — uses a strong key derivation function from the password
- You'll be prompted to enter/confirm a passphrase.

**Decrypt the file:**
```
openssl enc -aes-256-cbc -d -in message.enc -out message_decrypted.txt -pbkdf2
```
- `-d` flag tells OpenSSL to decrypt instead of encrypt.

### Asymmetric Encryption Example (RSA)

**1. Generate a private key:**
```
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
```

**2. Extract the public key:**
```
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

**3. Encrypt a message using the public key:**
```
openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in message.txt -out message.enc
```

**4. Decrypt using the private key:**
```
openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc -out message_decrypted.txt
```

### Hashing a File
```
openssl dgst -sha256 message.txt
```
- Outputs the SHA-256 hash of the file — useful for verifying integrity.

### Generating a Self-Signed TLS Certificate (for lab/testing use)
```
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```
- Creates a private key (`key.pem`) and a self-signed certificate (`cert.pem`) valid for 365 days.
- Useful for testing HTTPS locally — browsers will flag it as untrusted since it's not signed by a real CA.

> **Practice tip:** Try encrypting a file symmetrically, then try the RSA workflow — compare how key management differs between the two approaches.

---

## 5. Quick Summary Table

| Concept | Core Idea |
|---|---|
| Symmetric Encryption | One shared key, fast, used for bulk data (AES) |
| Asymmetric Encryption | Public/private key pair, solves key distribution (RSA) |
| Hashing | One-way fingerprint for integrity verification (SHA-256) |
| Digital Certificates | Bind identity to a public key, issued by a CA |
| SSL/TLS | Encrypts and authenticates data in transit (HTTPS) |
| OpenSSL | Command-line toolkit for real-world crypto operations |
