//
//  HSRuntime_switch_arm64.s
//  HSHUDHelper
//
//  Created by viewat on 16/6/24.
//  Copyright © 2016年 HS. All rights reserved.
//


#if defined(__x86_64__)

// R12~R15   callee-saved registers (must restore when return)
// %rax    temporary registers

// use R13 for the stack address
.macro PushStoreStackAddress

	movq    __hs_tmp_store(%rip), %rax
    addq    $$0x168, %rax
    movq    %rax, __hs_tmp_store(%rip)
    leaq    __hs_tmp_store(%rip), %rax
    addq    __hs_tmp_store(%rip), %rax
    movq    %r13, 0x160(%rax)
    movq    %rax, %r13

.endmacro

.macro PopStoreStackAddress
	movq    __hs_tmp_store(%rip), %r9
    subq    $$0x168, %r9
    movq    %r9, __hs_tmp_store(%rip)
    movq    %r13, %r9
    movq    0x160(%r9), %r13
.endmacro

.macro LoadStoreStackAddress

.endmacro

	.globl	_hs_switch_block_func
	.align	4, 0x90
_hs_switch_block_func:
    .cfi_startproc
    PushStoreStackAddress

    movq    %rbp, ( %r13) // save %rbp even though never changed
	movq	%rdi, 8( %r13)
	movq	%rsi, 16( %r13)
	movq	%rdx, 24( %r13)
	movq	%rcx, 32( %r13)
	movq	%r8, 40( %r13)
	movq	%r9, 48( %r13)

    // save %xmm0~%xmm7 for floating-point arguments
    movsd   %xmm0, 200( %r13)
    movsd   %xmm1, 216( %r13)
    movsd   %xmm2, 232( %r13)
    movsd   %xmm3, 248( %r13)
    movsd   %xmm4, 264( %r13)
    movsd   %xmm5, 280( %r13)
    movsd   %xmm6, 296( %r13)
    movsd   %xmm7, 312( %r13)


    // pop return address pointer from stack and save
    popq	%rax
    movq	%rax, 72( %r13)

    // x0(originSelector) = [self hs_selectorForOriginMethod:x1]
    movq    8( %r13), %rdi
    movq    16( %r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.2( %rip), %rsi

    callq	_objc_msgSend
    movq	%rax, 80( %r13)

    // [self hs_executeBlockBeforeMethod:originSelector]
    movq	80( %r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.4( %rip), %rsi
    movq	8( %r13), %rdi

    callq   _objc_msgSend

    // x0(originMethodReturn) = [self x0]
    movq	80( %r13), %rsi
    movq	8( %r13), %rdi
	movq	24( %r13), %rdx
	movq	32( %r13), %rcx
	movq	40( %r13), %r8
	movq	48( %r13), %r9
    // restore %xmm0~%xmm7 for floating-point arguments
    movsd   200( %r13), %xmm0
    movsd   216( %r13), %xmm1
    movsd   232( %r13), %xmm2
    movsd   248( %r13), %xmm3
    movsd   264( %r13), %xmm4
    movsd   280( %r13), %xmm5
    movsd   296( %r13), %xmm6
    movsd   312( %r13), %xmm7

    callq   _objc_msgSend
    movq	%rax, 88( %r13)
    movsd   %xmm0, 328( %r13)

    // [self hs_executeBlockAfterMethod:originSelector]
    movq	80( %r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.6( %rip), %rsi
    movq	8( %r13), %rdi

    callq   _objc_msgSend

    // restore (originMethodReturn) to return
    movq	88( %r13), %rax
    movsd   328( %r13), %xmm0
    // restore return address pointer and push to stack
    movq	72( %r13), %rdi
    pushq	%rdi

    PopStoreStackAddress
    retq
    .cfi_endproc


    .globl	_hs_switch_block_func_stret
	.align	4, 0x90
_hs_switch_block_func_stret:
    .cfi_startproc
    PushStoreStackAddress

    movq    %rbp, (%r13) // save %rbp even though never changed
	movq	%rdi, 8(%r13)
	movq	%rsi, 16(%r13)
	movq	%rdx, 24(%r13)
	movq	%rcx, 32(%r13)
	movq	%r8, 40(%r13)
	movq	%r9, 48(%r13)

    // save %xmm0~%xmm7 for floating-point arguments
    movsd   %xmm0, 200(%r13)
    movsd   %xmm1, 216(%r13)
    movsd   %xmm2, 232(%r13)
    movsd   %xmm3, 248(%r13)
    movsd   %xmm4, 264(%r13)
    movsd   %xmm5, 280(%r13)
    movsd   %xmm6, 296(%r13)
    movsd   %xmm7, 312(%r13)

    // pop return address pointer from stack and save
    popq	%rax
    movq	%rax, 72(%r13)

    // x0(originSelector) = [self hs_selectorForOriginMethod:x1]
    movq    16(%r13), %rdi
    movq    24(%r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.2(%rip), %rsi

    callq	_objc_msgSend
    movq	%rax, 80(%r13)

    // [self hs_executeBlockBeforeMethod:originSelector]
    movq	80(%r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.4(%rip), %rsi
    movq	16(%r13), %rdi

    // x0(originMethodReturn) = [self x0]
    movq	16(%r13), %rsi
    movq	8(%r13), %rdi
	movq	80(%r13), %rdx
	movq	32(%r13), %rcx
	movq	40(%r13), %r8
	movq	48(%r13), %r9
    // restore %xmm0~%xmm7 for floating-point arguments
    movsd   200(%r13), %xmm0
    movsd   216(%r13), %xmm1
    movsd   232(%r13), %xmm2
    movsd   248(%r13), %xmm3
    movsd   264(%r13), %xmm4
    movsd   280(%r13), %xmm5
    movsd   296(%r13), %xmm6
    movsd   312(%r13), %xmm7

    callq   _objc_msgSend_stret
    // if struct size less than 16, %rax and %rdx store the return
    movq	%rax, 88(%r13)
    movq	%rdx, 96(%r13)

    // [self hs_executeBlockAfterMethod:originSelector]
    movq	80(%r13), %rdx
    movq	L_OBJC_SELECTOR_REFERENCES_.6(%rip), %rsi
    movq	16(%r13), %rdi

    callq   _objc_msgSend

    // restore (originMethodReturn) to return
    movq	88(%r13), %rax
    movq	96(%r13), %rdx
    // restore return address pointer and push to stack
    movq	72(%r13), %rdi
    pushq	%rdi

    PopStoreStackAddress
    retq
    .cfi_endproc


    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.1:
	.asciz	"hs_selectorForOriginMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.2:
	.quad	L_OBJC_METH_VAR_NAME_.1

    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.3:
	.asciz	"hs_executeBlockBeforeMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.4:
	.quad	L_OBJC_METH_VAR_NAME_.3

    .section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.5:
	.asciz	"hs_executeBlockAfterMethod:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.align	3
L_OBJC_SELECTOR_REFERENCES_.6:
	.quad	L_OBJC_METH_VAR_NAME_.5


	.section	__DATA,__data
	.globl	__hs_tmp_store                  
	.align	4
___hs_tmp_store:
	.quad	1       // %rbp
	.quad	2       // %rdi~%r9
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10
    .quad	11      // replaceSelector
    .quad	12      // (return) %rax
    .quad	13      // (return) %rdx
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10      // %xmm0~%xmm7
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10      // (return)%xmm0
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16
    .quad	1
	.quad	2
    .quad	3
    .quad	4
    .quad	5
    .quad	6
    .quad	7
    .quad	8
    .quad	9
    .quad	10
    .quad	11
    .quad	12
    .quad	13
    .quad	14
    .quad	15
    .quad	16

#endif
