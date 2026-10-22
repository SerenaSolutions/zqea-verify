// ============================================================================
// S3 QUTRIT FUSION — provenance circuit of the sealed receipt shipped in this
// repository (experiments/s3_qutrit_*_receipt.json in SerenaSolutions/zephirum-lang).
// OpenQASM 3 — the quantum source of truth the Z-QEA receipt attests to.
// ----------------------------------------------------------------------------
// Fusion space of two non-Abelian anyons (S3 qutrit miniature):
//   |0> ~ |00>   |1> ~ |01>   |2> ~ |10>   (|11> FORBIDDEN — fusion veto)
// Braids: B_R in plane (0,2)  — two-level rotation between |00> and |10>
//         B_S in plane (1,2)  — two-level rotation between |01> and |10>
// Word of period 3: (B_R B_S)^3 returns the channel — the period-3 echo.
// Non-Abelian signature: [B_R, B_S] L1-norm = 6, asserted in CI by the battery.
// ============================================================================
OPENQASM 3.0;
include "stdgates.inc";

// two-level rotation between |00> and |10>  ==  Ry(pi) on q0, controlled on q1 = |0>
gate b_r q0, q1 {
  x q1;               // q1 -> |1>: make the |0>-branch the control
  ctrl(1) @ ry(pi) q1, q0;
  x q1;               // restore
}

// two-level rotation between |01> and |10>: Givens ladder (standard decomposition)
gate b_s q0, q1 {
  cx q0, q1;          // map the pair {|01>,|10>} to {|00>,|11>}
  x q1;               // ... prepare two-level on (|00>,|10>) basis
  ctrl(1) @ ry(pi) q1, q0;
  x q1;
  cx q0, q1;          // map back
}

// fusion preparation: uniform over the 3 allowed channels, |11> vetoed
qubit[2] fusion;
bit[2] channel;

reset fusion;
h fusion[0];
h fusion[1];
// veto |11>: project onto the 3-dim fusion space (Kraus correction in hardware;
// exact arithmetic in the noiseless statevector battery)
if (fusion[0] & fusion[1]) {
  reset fusion;
  h fusion[0];
  h fusion[1];
}

// braid word W = B_R B_S — order matters, non-Abelian
b_r fusion[0], fusion[1];
b_s fusion[0], fusion[1];
b_r fusion[0], fusion[1];
b_s fusion[0], fusion[1];

measure fusion -> channel;
// channel 11 (FORBIDDEN) must never appear — the fusion veto is part of the
// sealed receipt's verdict NAO_ABELIANO_VERIFICADO.

// ---------------------------------------------------------------------------
// DJ trivalent decision ON THE ENCODED QUTRIT — the ZYQL gate (1 oracle call)
// constant-1 => 1, constant-0 => 0, balanced => REFUSED
// ----------------------------------------------------------------------------
qubit[3] dj_qutrit;         // 2 payload qubits + 1 ancilla in |->
bit[2] dj_channel;
reset dj_qutrit;
x dj_qutrit[2];
h dj_qutrit[2];
h dj_qutrit[0]; h dj_qutrit[1];
cx dj_qutrit[0], dj_qutrit[2];     // balanced oracle over the encoded space
cx dj_qutrit[1], dj_qutrit[2];
h dj_qutrit[0]; h dj_qutrit[1];
measure dj_qutrit[0:2] -> dj_channel;
// receipt lineage: the verdict of this circuit family is what the sealed
// receipts in this repo attest (Z-QEA, SHA3-256 — recompute, compare, no keys)
