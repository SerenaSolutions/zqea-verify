# Changelog

## v2.0.0 — post-quantum core (2026-10-21)
- **ML-DSA-44 (FIPS 204, NIST)** signature verification: layer 2 of every Z-QEA receipt. Public key embedded in the receipt — verification needs no server, no CA, no key distribution.
- **Quantum entropy audit**: when present, the receipt's entropy provenance (IBM Quantum job id, backend, pool SHA3-256) is displayed.
- `--strict-pq` mode: requires the post-quantum layer (v1 receipts then fail).
- v1 receipts without the PQ layer keep verifying and are reported as LEGACY_V1.
- CI: new post-quantum battery job (sign VALID / tamper INVALID / v1 LEGACY).

## v1.0.0 — initial release
- SHA3-256 canonical seal verification (Z-QEA).
