//
//  HSRuntime_switch_arm64.s
//  HSHUDHelper
//
//  Created by viewat on 16/6/24.
//  Copyright © 2016年 HS. All rights reserved.
//


#if defined(__arm64__)
	.globl	_hs_switch_block_func
	.align	2
_hs_switch_block_func:        ; @hs_switch_block_func

    adrp	x9, __hs_tmp_store@PAGE
	add	x9, x9, __hs_tmp_store@PAGEOFF

// save x30 for return pointer
    mov	x10, X30
    str		x10, [x9]

// save x8 if a struct will be returned (location)
    str		x8, [x9, #8]

// save x0~x7 for params
    str		x0, [x9, #0x80]
    str		x1, [x9, #0x88]
    str		x2, [x9, #0x90]
    str		x3, [x9, #0x98]
    str		x4, [x9, #0xa0]
    str		x5, [x9, #0xa8]
    str		x6, [x9, #0xb0]
    str		x7, [x9, #0xb8]
// save v0~v7 for floating-point params
    str		d0, [x9, #0xc0]
    str		d1, [x9, #0xc8]
    str		d2, [x9, #0xd0]
    str		d3, [x9, #0xd8]
    str		d4, [x9, #0xe0]
    str		d5, [x9, #0xe8]
    str		d6, [x9, #0xf0]
    str		d7, [x9, #0xf8]

    // x0(originSelector) = [self hs_selectorForOriginMethod:x1]
    mov x2, x1

    adrp	x8, L_OBJC_SELECTOR_REFERENCES_.2@PAGE
	ldr	x8, [x8, L_OBJC_SELECTOR_REFERENCES_.2@PAGEOFF]
    mov x1, x8

    bl _objc_msgSend

    // x0(originMethodReturn) = [self x0]
    mov x1, x0

    adrp	x9, __hs_tmp_store@PAGE
	add	x9, x9, __hs_tmp_store@PAGEOFF

// restore interger/pointer params
    str     x1, [x9, #0x88]
    ldr		x0, [x9, #0x80]
    ldr		x2, [x9, #0x90]
    ldr		x3, [x9, #0x98]
    ldr		x4, [x9, #0xa0]
    ldr		x5, [x9, #0xa8]
    ldr		x6, [x9, #0xb0]
    ldr		x7, [x9, #0xb8]
// restore floating-pointer params
    ldr		d0, [x9, #0xc0]
    ldr		d1, [x9, #0xc8]
    ldr		d2, [x9, #0xd0]
    ldr		d3, [x9, #0xd8]
    ldr		d4, [x9, #0xe0]
    ldr		d5, [x9, #0xe8]
    ldr		d6, [x9, #0xf0]
    ldr		d7, [x9, #0xf8]
// restore struct location
    ldr     x8, [x9, #8]

    bl	_objc_msgSend

    // save x0(originMethodReturn)
    adrp	x8, __hs_tmp_store@PAGE
	add	x8, x8, __hs_tmp_store@PAGEOFF
    str		x0, [x8, #0x10]

    // [self hs_executeBlockForOriginSelector:originSelector]

    ldr     x2, [x8, #0x88]
    ldr		x0, [x8, #0x80]
    adrp	x8, L_OBJC_SELECTOR_REFERENCES_.4@PAGE
	ldr	x8, [x8, L_OBJC_SELECTOR_REFERENCES_.4@PAGEOFF]
    mov x1, x8

    bl _objc_msgSend

    // return originMethodReturn, and restore x30
    adrp	x8, __hs_tmp_store@PAGE
	add	x8, x8, __hs_tmp_store@PAGEOFF
    ldr		x0, [x8, #0x10]
	ldr		X30, [x8]
    ldr     x8, [x8, #8] // no need to restore x8, just ...
    
    ret



    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.1:               ; @OBJC_METH_VAR_NAME_.36
	.asciz	"hs_selectorForOriginMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3                       ; @OBJC_SELECTOR_REFERENCES_.37
L_OBJC_SELECTOR_REFERENCES_.2:
	.quad	L_OBJC_METH_VAR_NAME_.1

    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.3:               ; @OBJC_METH_VAR_NAME_.36
	.asciz	"hs_executeBlockForOriginSelector:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3                       ; @OBJC_SELECTOR_REFERENCES_.37
L_OBJC_SELECTOR_REFERENCES_.4:
	.quad	L_OBJC_METH_VAR_NAME_.3


	.section	__DATA,__data
	.globl	__hs_tmp_store                  ; @kexue
	.align	3
__hs_tmp_store:
	.quad	1                       ; 0x1
	.quad	2                       ; 0x2
    .quad	3                       ; 0x3
    .quad	4                       ; 0x3
    .quad	5                       ; 0x3
    .quad	6                       ; 0x3
    .quad	7                       ; 0x3
    .quad	8                       ; 0x3
    .quad	9                       ; 0x3
    .quad	10                       ; 0x3
    .quad	11                       ; 0x3
    .quad	12                       ; 0x3
    .quad	13                       ; 0x3
    .quad	14                       ; 0x3
    .quad	15                       ; 0x3
    .quad	16                       ; 0x3
    .quad	1                       ; 0x80 (x0~x7)
	.quad	2                       ; 0x2
    .quad	3                       ; 0x3
    .quad	4                       ; 0x3
    .quad	5                       ; 0x3
    .quad	6                       ; 0x3
    .quad	7                       ; 0x3
    .quad	8                       ; 0x3
    .quad	9                       ; 0xc0 (v0~v7)
    .quad	10                       ; 0x3
    .quad	11                       ; 0x3
    .quad	12                       ; 0x3
    .quad	13                       ; 0x3
    .quad	14                       ; 0x3
    .quad	15                       ; 0x3
    .quad	16                       ; 0x3


#endif
