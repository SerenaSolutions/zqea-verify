"""Z-QEA seal verifier battery: integrity must pass, tampering must fail."""
import os, json

HERE = os.path.dirname(__file__)
VA = os.path.join(HERE, "..", "zqea_verify.py")

def _ns():
    ns = {}
    exec(open(VA).read(), ns)
    return ns

def _load_master():
    return json.load(open(os.path.join(HERE, "..", "examples", "s3_qutrit_final_receipt.json")))

def test_master_receipt_integral():
    receipt = _load_master()
    ok, recomputed, why = _ns()["verify"](receipt)
    assert ok, ("master receipt must verify INTEGRAL", why, recomputed)

def test_tampered_receipt_broken():
    r = _load_master()
    r["data"] = str(r.get("data", "x")) + "tampered"
    ok, _, why = _ns()["verify"](r)
    assert not ok, ("tampered receipt must break", why)


def test_post_quantum_signature_roundtrip():
    ns = _ns()
    from zqea_pq import sign_receipt, verify_signature, sha3_seal
    rec = {"bateria": "pq", "valor": 7}
    rec = sign_receipt(rec)
    rec["selo_sha3_256"] = sha3_seal({k: v for k, v in rec.items() if k != "selo_sha3_256"})
    s, d = verify_signature(rec); assert s == "PQ_OK", (s, d)
    rec["valor"] = 8
    s, d = verify_signature(rec); assert s == "PQ_INVALID", (s, d)

def test_legacy_v1_receipt_reported_not_failed():
    ns = _ns()
    from zqea_pq import verify_signature, sha3_seal
    v1 = {"legacy": True}; v1["selo_sha3_256"] = sha3_seal(v1)
    s, d = verify_signature(v1); assert s == "LEGACY_V1", (s, d)
