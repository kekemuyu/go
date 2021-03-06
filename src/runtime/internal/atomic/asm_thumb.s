// Copyright 2015 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

TEXT ·Load(SB),NOSPLIT,$0-8
	MOVW  addr+0(FP), R0
	MOVW  (R0), R1
	DMB   MB_ISH
	MOVW  R1, ret+4(FP)
	RET

TEXT ·Store(SB),NOSPLIT,$0-8
	MOVW  addr+0(FP), R1
	MOVW  v+4(FP), R2
	DMB   MB_ISH
	MOVW  R2, (R1)
	DMB   MB_ISH
	RET

TEXT ·Cas(SB),NOSPLIT|NOFRAME,$0
	MOVW  ptr+0(FP), R1
	MOVW  old+4(FP), R2
	MOVW  new+8(FP), R3
casl:
	LDREX  (R1), R0
	CMP    R0, R2
	BNE    end
	DMB    MB_ISHST
	STREX  R3, (R1), R0
	CMP    $0, R0
	BNE    casl
end:
	MOVW.NE    $0, R0
	MOVW.P.EQ  $1, R0
	DMB.EQ     MB_ISH
	MOVB       R0, ret+12(FP)
	RET

TEXT ·Xchg(SB),NOSPLIT|NOFRAME,$0-12
	MOVW  addr+0(FP), R1
	MOVW  v+4(FP), R2
loop:
	LDREX  (R1), R0
	DMB    MB_ISHST
	STREX  R2, (R1), R3
	CMP    $0, R3
	BNE    loop
	DMB    MB_ISH
	MOVW   R0, ret+8(FP)
	RET

TEXT ·Xadd(SB),NOSPLIT|NOFRAME,$0-12
	MOVW  val+0(FP), R1
	MOVW  delta+4(FP), R2
loop:
	LDREX  (R1), R0
	DMB    MB_ISHST
	ADD    R2, R0
	STREX  R0, (R1), R3
	CMP    $0, R3
	BNE    loop
	DMB    MB_ISH
	MOVW   R0, ret+8(FP)
	RET

// stubs

TEXT ·Loadp(SB),NOSPLIT|NOFRAME,$0-8
	B   ·Load(SB)

TEXT ·LoadAcq(SB),NOSPLIT|NOFRAME,$0-8
	B   ·Load(SB)

TEXT ·Casp1(SB),NOSPLIT,$0-13
	B   ·Cas(SB)

TEXT ·CasRel(SB),NOSPLIT,$0-13
	B   ·Cas(SB)

TEXT ·StorepNoWB(SB),NOSPLIT,$0-8
	B   ·Store(SB)

TEXT ·StoreRel(SB),NOSPLIT,$0-8
	B   ·Store(SB)

TEXT ·Loadint64(SB),NOSPLIT,$0-12
	B   ·Load64(SB)

TEXT ·Xaddint64(SB),NOSPLIT,$0-20
	B   ·Xadd64(SB)

TEXT ·Cas64(SB),NOSPLIT,$0-21
	B   ·goCas64(SB)

TEXT ·Xadd64(SB),NOSPLIT,$0-20
	B   ·goXadd64(SB)

TEXT ·Xchg64(SB),NOSPLIT,$0-20
	B   ·goXchg64(SB)

TEXT ·Load64(SB),NOSPLIT,$0-12
	B   ·goLoad64(SB)

TEXT ·Store64(SB),NOSPLIT,$0-12
	B   ·goStore64(SB)
