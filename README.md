# Z-QEA Receipt Verifier

![seal](https://img.shields.io/badge/seal-SHA3--256-blue) ![license](https://img.shields.io/badge/license-MIT-blue)

**Verify the SHA3-256 seal (Z-QEA) of a receipt JSON.** `INTEGRAL` passes the job; a broken seal fails it. *Nothing executes silently.*

A Z-QEA receipt is a JSON document that carries its own integrity rule: the field
`selo_sha3_256` is the SHA3-256 of the canonical JSON of the receipt with that
field removed. This Action recomputes the seal and compares — any silent edit,
truncation or forgery of the receipt breaks the seal and fails the CI job.

## Usage

```yaml
- name: Verify Z-QEA receipt
  uses: SerenaSolutions/zqea-verify@v1
  with:
    receipt-file: experiments/s3_qutrit_final_receipt.json
```

### Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `receipt-file` | yes | Path to the receipt JSON to verify |

### Outputs

| Output | Description |
|--------|-------------|
| `status` | `INTEGRAL` or `BROKEN` |
| `seal` | Recomputed SHA3-256 seal |

Exit codes: `0` = seal matches, `1` = broken/malformed/missing seal (job fails).

## What it is for

Tamper-evident evidence in CI: quantum experiment receipts, model cards,
audit records, benchmark results — anything that must arrive *exactly as sealed*.
The receipt declares its own rule (`selo_regra`), so verification is a public
good: no server, no key, no trust in the publisher required. Aligns with
audit-trail expectations of governance standards (e.g. ISO/IEC 42001 AI
management).

Try it now: this repository's own CI verifies a real sealed receipt from the
[ZEPHIRUM quantum language](https://github.com/SerenaSolutions/zephirum-lang)
(S3 qutrit fusion, IBM Heron `ibm_fez` job IDs).

## Pricing

**Free forever.** Open source, MIT. Its job is to make sealed receipts a
public good. (A hosted signed-receipt tier — ML-DSA-44 / FIPS 204, receipt
registry — is declared roadmap, sold only when it exists.)

## Receipt format (minimal)

```json
{
  "spec": "...", "data": "...",
  "selo_regra": "SHA3-256 over canonical JSON without selo_sha3_256",
  "selo_sha3_256": "<hex>"
}
```

## License

MIT © 2026 Serena Solutions

## Prova de conceito (hardware real)

Bateria em modo estrito: 6/6 recibos válidos (selo + ML-DSA-44), fraude recusada nas duas camadas.

Recibo selado: [`poc/receipt_verifier_poc.json`](poc/receipt_verifier_poc.json) — verificável com `python3 zqea_verify.py poc/receipt_verifier_poc.json --strict-pq`.

Bateria completa do confronto multilíngue (OpenQASM 3, Qiskit, Cirq, PennyLane, Braket, Q#): [SerenaSolutions/quantum-poc](https://github.com/SerenaSolutions/quantum-poc).
