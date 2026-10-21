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
